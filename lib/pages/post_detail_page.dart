import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Post'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('posts').doc(postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Post não encontrado.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String title = data['title'] ?? 'Sem Título';
          final String content = data['content'] ?? '';
          final String category = data['category'] ?? 'Geral';
          final Timestamp? createdAt = data['createdAt'] as Timestamp?;
          final String authorName = data['authorName'] ?? 'Usuário Anônimo';
          
          String timeAgo = '';
          if (createdAt != null) {
            timeAgo = timeago.format(createdAt.toDate(), locale: 'pt_BR');
          }

          final theme = Theme.of(context);
          
          Color catColor = theme.primaryColor;
          if (category == 'Dúvidas') catColor = Colors.orange;
          else if (category == 'Conquistas') catColor = Colors.green;
          else if (category == 'Desabafos') catColor = Colors.purple;
          else if (category == 'Inclusão') catColor = Colors.blue;
          else if (category == 'Direitos') catColor = Colors.red;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: catColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(color: catColor, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(timeAgo, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.primaryColor,
                      child: Text(
                        authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(authorName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                // Em um app real, aqui iríamos construir um StreamBuilder para 'comments' (sub-collection)
                Text(
                  'Comentários',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Funcionalidade de comentários em breve!'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
