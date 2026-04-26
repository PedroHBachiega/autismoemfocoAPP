import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _especialidade = 'Psicólogo';
  String? _profissionalId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _motivo = '';
  
  bool _isLoading = false;

  final List<String> _especialidades = [
    'Psicólogo',
    'Fonoaudiólogo',
    'Terapeuta Ocupacional',
    'Neuropediatra',
    'Psiquiatra'
  ];

  // Dummy list of professionals. In a real app, this is fetched from Firestore
  // based on the selected _especialidade.
  final Map<String, List<Map<String, String>>> _profissionais = {
    'Psicólogo': [
      {'id': 'p1', 'name': 'Dra. Ana Silva'},
      {'id': 'p2', 'name': 'Dr. Marcos Santos'},
    ],
    'Fonoaudiólogo': [
      {'id': 'f1', 'name': 'Dra. Beatriz Costa'},
    ],
    'Terapeuta Ocupacional': [
      {'id': 't1', 'name': 'Dra. Carla Oliveira'},
      {'id': 't2', 'name': 'Dr. Thiago Mendes'},
    ],
    'Neuropediatra': [
      {'id': 'n1', 'name': 'Dra. Mariana Lima'},
    ],
    'Psiquiatra': [
      {'id': 'ps1', 'name': 'Dr. Roberto Alves'},
    ],
  };

  void _atualizarProfissionais() {
    // Reset professional selection when specialty changes
    setState(() {
      _profissionalId = _profissionais[_especialidade]?.first['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    _atualizarProfissionais();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _agendar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma data e horário.'), backgroundColor: Colors.red),
      );
      return;
    }

    _formKey.currentState!.save();

    final userProvider = context.read<AuthProvider>();
    final user = userProvider.user;
    
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você deve estar logado.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create a DateTime combining selected date and time
      final DateTime appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final selectedProfName = _profissionais[_especialidade]!
          .firstWhere((p) => p['id'] == _profissionalId)['name'];

      await FirebaseFirestore.instance.collection('agendamentos').add({
        'userId': user.uid,
        'patientName': userProvider.userProfile?['displayName'] ?? user.email,
        'especialidade': _especialidade,
        'profissionalId': _profissionalId,
        'profissionalName': selectedProfName,
        'date': appointmentDateTime,
        'motivo': _motivo,
        'status': 'Pendente',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consulta agendada com sucesso!'), backgroundColor: Colors.green),
        );
        context.go('/meus-agendamentos'); // Go to list of appointments
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao agendar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableProfs = _profissionais[_especialidade] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Consulta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Agendar Consulta',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                initialValue: _especialidade,
                decoration: const InputDecoration(labelText: 'Especialidade', border: OutlineInputBorder()),
                items: _especialidades.map((esp) => DropdownMenuItem(value: esp, child: Text(esp))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _especialidade = val;
                      _atualizarProfissionais();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _profissionalId,
                decoration: const InputDecoration(labelText: 'Profissional', border: OutlineInputBorder()),
                items: availableProfs.map((prof) => DropdownMenuItem(value: prof['id'], child: Text(prof['name']!))).toList(),
                onChanged: (val) => setState(() => _profissionalId = val),
                validator: (val) => val == null ? 'Selecione um profissional' : null,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedDate == null
                          ? 'Escolher Data'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime == null
                          ? 'Escolher Horário'
                          : _selectedTime!.format(context)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Motivo da Consulta',
                  border: OutlineInputBorder(),
                  hintText: 'Breve descrição do motivo',
                ),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Informe o motivo' : null,
                onSaved: (val) => _motivo = val!,
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _agendar,
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Confirmar Agendamento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
