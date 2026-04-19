import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perguntas Frequentes (FAQ)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          _FAQItem(
            question: 'O que é o Transtorno do Espectro Autista (TEA)?',
            answer: 'O TEA é um transtorno do neurodesenvolvimento que afeta, na maioria das vezes, a comunicação, a interação social e o comportamento. Cada pessoa no espectro é única.',
          ),
          _FAQItem(
            question: 'Como solicitar a Ciptea?',
            answer: 'A Carteira de Identificação da Pessoa com TEA pode ser solicitada através dos órgãos estaduais ou municipais específicos da sua região, geralmente de forma gratuita. No app, vá em "Leis e Direitos" para mais detalhes.',
          ),
          _FAQItem(
            question: 'O Autismo tem cura?',
            answer: 'O autismo não é uma doença, portanto não tem cura. É uma condição neurológica ao longo da vida, que pode ser acompanhada de terapias para maximizar a autonomia e qualidade de vida.',
          ),
          _FAQItem(
            question: 'Como funciona o sistema de Gamificação do app?',
            answer: 'Ao interagir com a comunidade (criando posts, comentando e curtindo), você ganha pontos e desbloqueia badges que aparecem no seu perfil.',
          ),
        ],
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.question, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Text(
                widget.answer,
                style: TextStyle(height: 1.5, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.85)),
              ),
            ),
        ],
      ),
    );
  }
}
