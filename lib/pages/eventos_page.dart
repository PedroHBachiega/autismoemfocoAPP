import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos e Ações'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('eventos')
            // AJUSTE 1: Nome do campo no seu print é 'createAt'
            .orderBy('createAt', descending: true) 
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // DICA: Se der erro de "Index", clique no link que aparecerá no console
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final eventos = snapshot.data?.docs ?? [];

          if (eventos.isEmpty) {
            return const Center(
              child: Text('Nenhum evento programado no momento.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: eventos.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Próximos Eventos',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                );
              }

              final doc = eventos[index - 1];
              final data = doc.data() as Map<String, dynamic>;

              // AJUSTE 2: Mapeando os nomes exatos do seu print
              return _buildEventoCard(
                context,
                titulo: data['titulo'] ?? 'Sem título',
                data: data['dataEvento'] != null 
                ? DateFormat('dd/MM/yyyy HH:mm').format((data['dataEvento'] as Timestamp).toDate())
                : 'Data a definir',
                local: data['local'] ?? 'Local a definir',
                descricao: data['descricao'] ?? '',
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventoCard(BuildContext context,
      {required String titulo,
      required String data,
      required String local,
      required String descricao}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 18, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(child: Text(data, style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.red.shade400),
                const SizedBox(width: 8),
                Expanded(child: Text(local, style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
            const Divider(height: 24),
            Text(
              descricao,
              style: TextStyle(
                  height: 1.5,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.85)),
            ),
          ],
        ),
      ),
    );
  }
}