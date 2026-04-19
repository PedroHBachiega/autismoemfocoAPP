import 'package:flutter/material.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos e Ações'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Próximos Eventos',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 24),
            // Example Static Events that were normally queried or hardcoded
            _buildEventoCard(
              context,
              titulo: 'Palestra: Autismo na Vida Adulta',
              data: '15 de Novembro de 2024',
              local: 'Auditório Principal - UNIVESP',
              descricao: 'Uma roda de conversa com especialistas e autistas adultos sobre os desafios no mercado de trabalho e vida independente.',
            ),
            _buildEventoCard(
              context,
              titulo: 'Encontro de Famílias Atípicas',
              data: '02 de Abril de 2024',
              local: 'Parque Ibirapuera - Portão 3',
              descricao: 'No Dia Mundial de Conscientização do Autismo, teremos um encontro para famílias com piquenique e atividades adaptadas para as crianças.',
            ),
            _buildEventoCard(
              context,
              titulo: 'Workshop de Educação Inclusiva',
              data: '20 de Janeiro de 2025',
              local: 'Online (Zoom)',
              descricao: 'Capacitação gratuita para professores da rede pública e privada sobre metodologias de ensino inclusivo e adaptação de material.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventoCard(BuildContext context, {required String titulo, required String data, required String local, required String descricao}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1),
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
                Icon(Icons.calendar_today, size: 18, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(data, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.red.shade400),
                const SizedBox(width: 8),
                Text(local, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const Divider(height: 24),
            Text(
              descricao,
              style: TextStyle(height: 1.5, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.85)),
            ),
          ],
        ),
      ),
    );
  }
}
