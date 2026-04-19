import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class ComunidadePage extends StatelessWidget {
  const ComunidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidade'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final posts = snapshot.data?.docs ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('Nenhum post encontrado.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final doc = posts[index];
              final data = doc.data() as Map<String, dynamic>;
              return _PostCard(postId: doc.id, data: data);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          context.push('/posts/create');
        },
        tooltip: 'Criar Post',
        child: const Icon(Icons.add),
      ),
    );
  }

}

class _PostCard extends StatelessWidget {
  final String postId;
  final Map<String, dynamic> data;

  const _PostCard({
    required this.postId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String title = data['title'] ?? 'Sem Título';
    final String content = data['content'] ?? '';
    final String category = data['category'] ?? 'Geral';
    final Timestamp? createdAt = data['createdAt'] as Timestamp?;
    final String authorName = data['authorName'] ?? 'Usuário Anônimo';

    String timeAgo = '';
    if (createdAt != null) {
      timeAgo = timeago.format(createdAt.toDate(), locale: 'pt_BR');
    }

    Color catColor = theme.primaryColor;
    switch (category) {
      case 'Dúvidas': catColor = Colors.orange; break;
      case 'Conquistas': catColor = Colors.green; break;
      case 'Desabafos': catColor = Colors.purple; break;
      case 'Inclusão': catColor = Colors.blue; break;
      case 'Direitos': catColor = Colors.red; break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.push('/posts/$postId');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: catColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(color: catColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: theme.primaryColor,
                    child: Text(
                      authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(authorName, style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text('Comentar', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
