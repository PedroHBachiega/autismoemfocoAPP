import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../providers/auth_provider.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

   int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location == '/') return 0;
    if (location.startsWith('/eventos')) return 1;
    if (location.startsWith('/agendamento')) return 2;
    if (location.startsWith('/comunidade')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
  }

  @override

  Widget build(BuildContext context) {
    final isDark = context.select((ThemeProvider theme) => theme.isDark);
    final isLoggedIn = context.select((AuthProvider auth) => auth.user != null);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autismo em Foco'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<ThemeProvider>().toggleTheme();
            },
            tooltip: 'Alternar Tema',
          ),
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.read<AuthProvider>().logout();
              },
              tooltip: 'Sair',
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre o Autismo'),
              onTap: () {
                context.pop();
                context.go('/sobreautismo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Tratamentos'),
              onTap: () {
                context.pop();
                context.go('/tratamentos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: const Text('Leis e Direitos'),
              onTap: () {
                context.pop();
                context.go('/leisedireitos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text('Meus Agendamentos'),
              onTap: () {
                context.pop();
                context.go('/meus-agendamentos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Sobre a Equipe'),
              onTap: () {
                context.pop();
                context.go('/sobre');
              },
            ),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'Agendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Comunidade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          HapticFeedback.selectionClick();
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/eventos');
              break;
              case 2:
              context.go('/agendamento');
              break;
            case 3:
              context.go('/comunidade');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}
