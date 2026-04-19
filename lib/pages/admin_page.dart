import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24.0),
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          _buildAdminAction(
            context,
            icon: Icons.article,
            title: 'Gerenciar Posts',
            color: Colors.blue,
            route: '/admin/posts',
          ),
          _buildAdminAction(
            context,
            icon: Icons.event,
            title: 'Cadastrar Evento',
            color: Colors.purple,
            route: '/cadastro-evento',
          ),
          _buildAdminAction(
            context,
            icon: Icons.people,
            title: 'Gerenciar Usuários',
            color: Colors.green,
            route: null, // Placeholder pro futuro
          ),
          _buildAdminAction(
            context,
            icon: Icons.calendar_month,
            title: 'Agendamentos',
            color: Colors.orange,
            route: null, // Placeholder pro futuro
          ),
        ],
      ),
    );
  }

  Widget _buildAdminAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required String? route,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: route != null ? () => context.push(route) : () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: 4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
