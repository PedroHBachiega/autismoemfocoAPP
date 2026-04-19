import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationCard(
            context,
            icon: Icons.chat,
            color: Colors.blue,
            title: 'Novo comentário no seu post',
            time: 'Há 5 minutos',
            isRead: false,
          ),
          _buildNotificationCard(
            context,
            icon: Icons.calendar_month,
            color: Colors.orange,
            title: 'Lembrete de Consulta',
            time: 'Há 2 horas',
            isRead: true,
          ),
          _buildNotificationCard(
            context,
            icon: Icons.star,
            color: Colors.green,
            title: 'Você desbloqueou um novo Badge!',
            time: 'Ontem',
            isRead: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String time,
    required bool isRead,
  }) {
    return Card(
      elevation: isRead ? 0 : 2,
      color: isRead ? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Text(time),
        trailing: isRead ? null : Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
