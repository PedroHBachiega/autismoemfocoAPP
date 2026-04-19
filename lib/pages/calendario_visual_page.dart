import 'package:flutter/material.dart';

class CalendarioVisualPage extends StatelessWidget {
  const CalendarioVisualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário Visual'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: const Text(
                'O calendário visual ajuda na previsibilidade do dia a dia, diminuindo a ansiedade.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            _buildTarefa(context, 'Acordar e Arrumar a Cama', Icons.wb_sunny, Colors.orange),
            _buildTarefa(context, 'Tomar Café da Manhã', Icons.free_breakfast, Colors.brown),
            _buildTarefa(context, 'Escola / Terapia', Icons.school, Colors.blue),
            _buildTarefa(context, 'Almoço', Icons.restaurant, Colors.green),
            _buildTarefa(context, 'Momento de Brincar', Icons.toys, Colors.purple),
            _buildTarefa(context, 'Banho', Icons.bathtub, Colors.teal),
            _buildTarefa(context, 'Jantar', Icons.dinner_dining, Colors.deepOrange),
            _buildTarefa(context, 'Dormir', Icons.nightlight_round, Colors.indigo),
          ],
        ),
      ),
    );
  }

  Widget _buildTarefa(BuildContext context, String nome, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        trailing: const Icon(Icons.check_box_outline_blank, size: 32, color: Colors.grey),
      ),
    );
  }
}
