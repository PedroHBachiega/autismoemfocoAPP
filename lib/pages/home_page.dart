import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Banner
          Container(
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/puzzle-hand.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black54,
                  BlendMode.darken,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Compreender Para Incluir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Autismo em Foco',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.go('/sobre');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      minimumSize: const Size(0, 48),
                    ),
                    child: const Text('Saiba mais', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),

          // Info Cards
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _InfoCard(
                  icon: Icons.help_outline,
                  title: 'O que é o autismo?',
                  description: 'Conheça as principais características do transtorno do espectro autista e como ele se manifesta.',
                  route: '/sobreautismo',
                ),
                _InfoCard(
                  icon: Icons.balance,
                  title: 'Leis relacionadas',
                  description: 'Confira os direitos das pessoas com autismo garantidos por lei.',
                  route: '/leisedireitos',
                ),
                _InfoCard(
                  icon: Icons.calendar_month,
                  title: 'Datas Especiais',
                  description: 'Descubra eventos e datas importantes para a conscientização sobre o autismo.',
                  route: '/eventos',
                ),
              ],
            ),
          ),

          // Community Section
          Container(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(Icons.group, size: 48, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Sobre nossa comunidade',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'A comunidade Autismo em Foco é um espaço online criado para todos que convivem com o Transtorno do Espectro Autista (TEA) – sejam pais, familiares, profissionais ou pessoas autistas. Aqui, compartilhamos experiências, conhecimentos e apoio mútuo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nosso objetivo é proporcionar um ambiente acolhedor onde todos possam encontrar informações confiáveis, trocar experiências e construir uma rede de apoio. Acreditamos que juntos somos mais fortes e podemos criar um mundo mais inclusivo para as pessoas com autismo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String route;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                context.go(route);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(0, 48),
              ),
              child: const Text('Acessar'),
            ),
          ],
        ),
      ),
    );
  }
}
