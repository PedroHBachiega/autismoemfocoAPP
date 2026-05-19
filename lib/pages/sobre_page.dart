import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre a Equipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'A Equipe Autismo em Foco',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Somos um grupo de estudantes dedicados a criar ferramentas e promover a conscientização sobre o Transtorno do Espectro Autista. Nosso objetivo é facilitar o acesso à informação, apoio e serviços, através de tecnologia de ponta.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16.0,
              runSpacing: 24.0,
              alignment: WrapAlignment.center,
              children: [
                _buildTeamMember(
                  context,
                  name: 'Pedro Henrique Bachiega',
                  role: 'Desenvolvedor',
                  imagePath: 'assets/images/pedrobachiega.png',
                  githubUrl: 'https://github.com/pedrohbachiega',
                ),
                _buildTeamMember(
                  context,
                  name: 'Pedro Henrique Scabelo',
                  role: 'Desenvolvedor Front-end',
                  imagePath: 'assets/images/pedroscabelo.png',
                  githubUrl: 'https://github.com/PedroHS05',
                ),
                _buildTeamMember(
                  context,
                  name: 'Pedro de Souza',
                  role: 'Desenvolvedor Back-End',
                  imagePath: 'assets/images/pedrosouza.png',
                  githubUrl: 'https://github.com/Pedro4Albuquerque',
                ),
                _buildTeamMember(
                  context,
                  name: 'Vitor Hugo',
                  role: 'Padrão / Dev',
                  imagePath: 'assets/images/vitor.png',
                  githubUrl: 'https://github.com/VitorBZS',
                ),
                _buildTeamMember(
                  context,
                  name: 'Igor',
                  role: 'Desenvolvedor',
                  imagePath: 'assets/images/igor.png',
                  githubUrl: 'https://github.com/igorferreira083',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context, {
    required String name,
    required String role,
    required String imagePath,
    required String githubUrl,
  }) {
    return SizedBox(
      width: 160,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: AssetImage(imagePath),
            onBackgroundImageError: (e, s) => debugPrint("Erro ao carregar $imagePath"),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: Image.asset('assets/images/github.png', width: 24, height: 24, color: Theme.of(context).iconTheme.color),
            onPressed: () => _launchUrl(githubUrl),
            tooltip: 'GitHub',
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Não foi possível abrir $url');
    }
  }
}
