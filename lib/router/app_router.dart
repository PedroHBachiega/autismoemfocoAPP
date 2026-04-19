import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_scaffold.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/recuperar_senha_page.dart';
import '../pages/sobre_autismo_page.dart';
import '../pages/tratamentos_page.dart';
import '../pages/sobre_page.dart';
import '../pages/leis_direitos_page.dart';
import '../pages/eventos_page.dart';
import '../pages/profile_page.dart';
import '../pages/comunidade_page.dart';
import '../pages/criar_post_page.dart';
import '../pages/post_detail_page.dart';
import '../pages/agendamento_page.dart';
import '../pages/meus_agendamentos_page.dart';
import '../pages/admin_page.dart';
import '../pages/admin_posts_page.dart';
import '../pages/cadastro_evento_page.dart';
import '../pages/chat_page.dart';
import '../pages/mapa_page.dart';
import '../pages/notifications_page.dart';
import '../pages/faq_page.dart';
import '../pages/calendario_visual_page.dart';

// Placeholder Pages - Will be implemented in Phase 4 & 5
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final bool loggedIn = authProvider.user != null;
      final bool isAuthRoute = state.uri.path == '/login' || 
                               state.uri.path == '/register' || 
                               state.uri.path == '/recuperar-senha';

      final publicRoutes = [
        '/', '/login', '/register', '/recuperar-senha',
        '/sobreautismo', '/tratamentos', '/sobre', '/leisedireitos', '/eventos'
      ];
      
      final bool isPublicRoute = publicRoutes.contains(state.uri.path);

      if (!loggedIn && !isPublicRoute) {
        return '/login';
      }
      
      // If user is already logged in, they shouldn't see login/register pages
      if (loggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      // Auth Routes (no scaffold)
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/recuperar-senha', builder: (context, state) => const RecuperarSenhaPage()),

      // Main App Routes wrapped in Scaffold
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          // Public
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(path: '/sobreautismo', builder: (context, state) => const SobreAutismoPage()),
          GoRoute(path: '/tratamentos', builder: (context, state) => const TratamentosPage()),
          GoRoute(path: '/sobre', builder: (context, state) => const SobrePage()),
          GoRoute(path: '/leisedireitos', builder: (context, state) => const LeisDireitosPage()),
          GoRoute(path: '/eventos', builder: (context, state) => const EventosPage()),

          // Protected
          GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
          GoRoute(path: '/comunidade', builder: (context, state) => const ComunidadePage()),
          GoRoute(path: '/posts/create', builder: (context, state) => const CriarPostPage()),
          GoRoute(path: '/posts/:id', builder: (context, state) => PostDetailPage(postId: state.pathParameters['id']!)),
          GoRoute(path: '/agendamento', builder: (context, state) => const AgendamentoPage()),
          GoRoute(path: '/meus-agendamentos', builder: (context, state) => const MeusAgendamentosPage()),
          GoRoute(path: '/chat', builder: (context, state) => const ChatPage()),
          GoRoute(path: '/mapa', builder: (context, state) => const MapaPage()),
          GoRoute(path: '/notifications', builder: (context, state) => const NotificationsPage()),
          GoRoute(path: '/faq', builder: (context, state) => const FAQPage()),
          GoRoute(path: '/calendario-visual', builder: (context, state) => const CalendarioVisualPage()),
          
          // Admin
          GoRoute(path: '/admin', builder: (context, state) => const AdminPage()),
          GoRoute(path: '/admin/posts', builder: (context, state) => const AdminPostsPage()),
          GoRoute(path: '/cadastro-evento', builder: (context, state) => const CadastroEventoPage()),
        ],
      ),
    ],
  );
}
