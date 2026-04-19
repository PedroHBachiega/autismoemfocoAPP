import 'package:flutter/material.dart';

class TratamentosPage extends StatelessWidget {
  const TratamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamentos e Terapias'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Abordagens Terapêuticas',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cada pessoa com autismo é única, e por isso não existe um tratamento único para todos. As intervenções devem ser personalizadas e baseadas nas necessidades específicas do indivíduo.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          _buildTratamentoCard(
            context,
            imagePath: 'assets/images/aba.jpg',
            title: 'Terapia ABA (Análise do Comportamento Aplicada)',
            description: 'Uma abordagem baseada na ciência do comportamento que busca ensinar novas habilidades e reduzir comportamentos prejudiciais, utilizando reforço positivo.',
          ),
          _buildTratamentoCard(
            context,
            imagePath: 'assets/images/fonoaudiologia.jpg',
            title: 'Fonoaudiologia',
            description: 'Fundamental para o desenvolvimento da fala, linguagem e comunicação alternativa, além de auxiliar nas questões alimentares e dificuldade de mastigação.',
          ),
          _buildTratamentoCard(
            context,
            imagePath: 'assets/images/terapeutaOcupacional.jpg',
            title: 'Terapia Ocupacional',
            description: 'Ajuda a pessoa a desenvolver habilidades para as atividades do dia a dia, promovendo a independência funcional. Principalmente em Integração Sensorial.',
          ),
          _buildTratamentoCard(
            context,
            imagePath: 'assets/images/psicoterapia.jpg',
            title: 'Psicoterapia (TCC)',
            description: 'A Terapia Cognitivo-Comportamental ajuda na regulação emocional, controle de ansiedade e desenvolvimento de habilidades sociais, muito útil para jovens e adultos autistas.',
          ),
          _buildTratamentoCard(
            context,
            imagePath: 'assets/images/neuropediatra.jpg',
            title: 'Acompanhamento Médico',
            description: 'O acompanhamento com Neuropediatra ou Psiquiatra é essencial para monitorar o desenvolvimento e tratar condições coexistentes como TDAH, ansiedade ou epilepsia, através do tratamento medicamentoso.',
          ),
        ],
      ),
    );
  }

  Widget _buildTratamentoCard(BuildContext context, {required String imagePath, required String title, required String description}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(height: 1.5, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
