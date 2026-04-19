import 'package:flutter/material.dart';

class SobreAutismoPage extends StatelessWidget {
  const SobreAutismoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Autismo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'O que é o Transtorno do Espectro Autista (TEA)?',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'O Transtorno do Espectro Autista (TEA) é uma condição do desenvolvimento neurológico que afeta a forma como a pessoa se comunica, interage com os outros e percebe o mundo ao seu redor. A palavra "espectro" é usada porque as características e a intensidade dos sintomas variam amplamente de uma pessoa para outra.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            Text(
              'Principais Características',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              icon: Icons.chat_bubble_outline,
              title: 'Comunicação e Interação Social',
              description: 'Dificuldades em manter uma conversa, compreender expressões faciais e tom de voz, além de desafios em estabelecer e manter relacionamentos.',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              icon: Icons.sync,
              title: 'Padrões de Comportamento Restritos e Repetitivos',
              description: 'Interesses intensos em tópicos específicos, apego a rotinas e movimentos repetitivos (como balançar as mãos ou o corpo).',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              context,
              icon: Icons.visibility,
              title: 'Sensibilidade Sensorial',
              description: 'Reações incomuns a estímulos sensoriais como sons, luzes, texturas ou cheiros (hipersensibilidade ou hiposensibilidade).',
            ),
            const SizedBox(height: 32),
            Text(
              'A Importância do Diagnóstico Precoce',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'O diagnóstico precoce e a intervenção adequada são fundamentais para o desenvolvimento e a qualidade de vida da pessoa com autismo. Se você identificar sinais de TEA em uma criança ou adulto, procure a avaliação de profissionais especializados (neuropediatra, psiquiatra ou psicólogo especialista em neurodesenvolvimento).',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, {required IconData icon, required String title, required String description}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: theme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
