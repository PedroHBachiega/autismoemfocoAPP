import 'package:flutter/material.dart';

// In a real application, this would save the event to Firestore 'eventos' collection,
// but for now it will just show a UI similar to the Criar Post screen.
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
  DateTime? _data;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _data) {
      setState(() => _data = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma data para o evento.'), backgroundColor: Colors.red),
      );
      return;
    }

    _formKey.currentState!.save();
    
    setState(() => _isLoading = true);

    // Mock API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento cadastrado com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Evento'),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título do Evento',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Informe o título' : null,
                onSaved: (val) => _titulo = val!,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_month),
                label: Text(_data == null ? 'Escolher Data' : '${_data!.day}/${_data!.month}/${_data!.year}'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Localização ou Link',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Informe o local' : null,
                onSaved: (val) => _local = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (val) => val == null || val.isEmpty ? 'Descreva o evento' : null,
                onSaved: (val) => _descricao = val!,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Cadastrar Evento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
