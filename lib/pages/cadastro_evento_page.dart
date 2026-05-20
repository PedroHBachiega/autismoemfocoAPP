import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class CadastroEventoPage extends StatefulWidget {
  const CadastroEventoPage({super.key});

  @override
  State<CadastroEventoPage> createState() => _CadastroEventoPageState();
}

class _CadastroEventoPageState extends State<CadastroEventoPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _titulo = '';
  String _descricao = '';
  String _local = '';
  String _categoria = 'Palestra';
  DateTime? _data;
  
  // NOVAS VARIÁVEIS PARA HORÁRIO
  TimeOfDay? _horarioInicio;
  TimeOfDay? _horarioFim;
  
  bool _isLoading = false;

  // Função para formatar o TimeOfDay para "HH:mm"
  String _formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _data = picked);
  }

  // FUNÇÃO PARA SELECIONAR HORÁRIO
  Future<void> _selectTime(BuildContext context, bool isInicio) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isInicio ? const TimeOfDay(hour: 9, minute: 0) : const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isInicio) _horarioInicio = picked;
        else _horarioFim = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_data == null || _horarioInicio == null || _horarioFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data e os horários.'), backgroundColor: Colors.red),
      );
      return;
    }

    _formKey.currentState!.save();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('eventos').add({
        'titulo': _titulo,
        'descricao': _descricao,
        'local': _local,
        'categoria': _categoria,
        'dataEvento': Timestamp.fromDate(_data!),
        // SALVANDO NO FORMATO "11:00 - 23:00"
        'horario': '${_formatTime(_horarioInicio)} - ${_formatTime(_horarioFim)}',
        'createAt': FieldValue.serverTimestamp(),
        'organizador': auth.userProfile?['displayName'] ?? 'Administrador',
        'status': 'ativo',
        'vagas': 50,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evento publicado!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Evento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título do Evento', border: OutlineInputBorder(), prefixIcon: Icon(Icons.title)),
                validator: (val) => val == null || val.isEmpty ? 'Informe o título' : null,
                onSaved: (val) => _titulo = val!,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
                items: ['Palestra', 'Encontro', 'Workshop', 'Ação Social'].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _categoria = val!),
              ),
              const SizedBox(height: 16),

              // SEÇÃO DE DATA E HORA
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(_data == null ? 'Data' : '${_data!.day}/${_data!.month}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context, true),
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text(_horarioInicio == null ? 'Início' : _formatTime(_horarioInicio)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context, false),
                      icon: const Icon(Icons.access_time_filled, size: 18),
                      label: Text(_horarioFim == null ? 'Fim' : _formatTime(_horarioFim)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Localização', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on)),
                validator: (val) => val == null || val.isEmpty ? 'Informe o local' : null,
                onSaved: (val) => _local = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
                maxLines: 4,
                validator: (val) => val == null || val.isEmpty ? 'Descreva o evento' : null,
                onSaved: (val) => _descricao = val!,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('PUBLICAR EVENTO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}