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
  final authProvider = context.watch<AuthProvider>(); // Pega o provider
  final isLoggedIn = authProvider.user != null;
  final isAdmin = authProvider.userProfile?['userType'] == 'admin';
  final theme = Theme.of(context);

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
        child: Column(
          children: [
            // Cabeçalho do Drawer
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            
            // Área expansível com os itens do topo
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (isAdmin)
                  ListTile(
                    leading: const Icon(Icons.security, color: Colors.red),
                    title: const Text('Área do Administrador', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () {
                      context.pop();
                      context.push('/admin');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Sobre o Autismo'),
                    onTap: () {
                      context.pop();
                      context.push('/sobreautismo');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text('Tratamentos'),
                    onTap: () {
                      context.pop();
                      context.push('/tratamentos');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.gavel),
                    title: const Text('Leis e Direitos'),
                    onTap: () {
                      context.pop();
                      context.push('/leisedireitos');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.event_available),
                    title: const Text('Meus Agendamentos'),
                    onTap: () {
                      context.pop();
                      context.push('/meus-agendamentos');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Sobre a Equipe'),
                    onTap: () {
                      context.pop();
                      context.push('/sobre');
                    },
                  ),
                ],
              ),
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.question_mark), // Ícone alterado para FAQ
              title: const Text('Dúvidas Frequentes'),
              onTap: () {
                context.pop();
                context.push('/faq');
              },
            ),
            const SizedBox(height: 8), // Margem de segurança inferior
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