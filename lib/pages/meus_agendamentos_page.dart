import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class MeusAgendamentosPage extends StatelessWidget {
  const MeusAgendamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Agendamentos')),
        body: const Center(child: Text('Você precisa estar logado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agendamentos')
            .where('userId', isEqualTo: user.uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Se houver erro de índice, o link pro console vai aparecer no snapshot.error
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: SelectableText('Erro: ${snapshot.error}')),
            );
          }

          final agendamentos = snapshot.data?.docs ?? [];

          if (agendamentos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Você ainda não tem consultas agendadas.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/agendamento'),
                    child: const Text('Agendar Nova Consulta'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: agendamentos.length,
            itemBuilder: (context, index) {
              final data = agendamentos[index].data() as Map<String, dynamic>;
              return _buildAgendamentoCard(context, data);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/agendamento'),
        icon: const Icon(Icons.add),
        label: const Text('Nova Consulta'),
      ),
    );
  }

  Widget _buildAgendamentoCard(BuildContext context, Map<String, dynamic> data) {
    final especialidade = data['especialidade'] ?? 'Indefinido';
    final profissionalName = data['profissionalName'] ?? 'Profissional';
    final motivo = data['motivo'] ?? '';
    final status = data['status'] ?? 'Pendente';
    final Timestamp? dateTimestamp = data['date'];

    String formattedDate = '';
    String formattedTime = '';

    if (dateTimestamp != null) {
      final dt = dateTimestamp.toDate();
      formattedDate = DateFormat('dd/MM/yyyy').format(dt);
      formattedTime = DateFormat('HH:mm').format(dt);
    }

    Color statusColor = Colors.orange;
    if (status == 'Confirmado') statusColor = Colors.green;
    else if (status == 'Cancelado') statusColor = Colors.red;
    else if (status == 'Realizado') statusColor = Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(especialidade, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Com: $profissionalName', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Horário: $formattedTime'),
              ],
            ),
            if (motivo.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text('Motivo: $motivo', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600)),
            ],
          ],
        ),
      ),
    );
  }
}
