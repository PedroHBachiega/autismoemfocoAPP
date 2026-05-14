import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Verifique se o caminho está correto

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

  // --- FUNÇÃO PARA CURTIR / DESCURTIR ---
  Future<void> _toggleLike(String currentUid, List likedBy) async {
    HapticFeedback.mediumImpact();
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    if (likedBy.contains(currentUid)) {
      // Se já curtiu, remove o UID da lista
      await postRef.update({
        'likedBy': FieldValue.arrayRemove([currentUid]) // Corretamente arrayRemove
      });
    } else {
      // Se não curtiu, adiciona o UID na lista
      await postRef.update({
        'likedBy': FieldValue.arrayUnion([currentUid]) // O CORRETO É: arrayUnion
      });
    }
  }

  // --- FUNÇÃO PARA DELETAR POST ---
  Future<void> _deletePost(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Post?'),
        content: const Text('Isso apagará o post permanentemente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('posts').doc(id).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post removido!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao deletar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final String currentUid = authProvider.user?.uid ?? '';
    
    final String title = data['title'] ?? 'Sem Título';
    final String content = data['content'] ?? '';
    final String category = data['category'] ?? 'Geral';
    final Timestamp? createdAt = data['createdAt'] as Timestamp?;
    final String authorUid = data['uid'] ?? data['authorId'] ?? data['userId'] ?? '';
    final String authorNameInPost = data['authorName'] ?? '';

    // Lógica de Curtidas
    final List likedBy = data['likedBy'] ?? [];
    final bool isLiked = likedBy.contains(currentUid);

    // Verifica se o post é do usuário logado
    final bool isMine = currentUid.isNotEmpty && currentUid == authorUid;

    String timeAgo = createdAt != null ? timeago.format(createdAt.toDate(), locale: 'pt_BR') : '';

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
                    child: Text(category, style: TextStyle(color: catColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    children: [
                      Text(timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      if (isMine)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          onPressed: () => _deletePost(context, postId),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(content, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8))),
              const SizedBox(height: 16),
              
              // Bloco do Autor
              if (authorUid.isEmpty)
                _buildAuthorRow(authorNameInPost.isNotEmpty ? authorNameInPost : 'Usuário', theme, isLiked, likedBy.length, currentUid, likedBy)
              else
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(authorUid).get(),
                  builder: (context, userSnapshot) {
                    String name = authorNameInPost.isNotEmpty ? authorNameInPost : 'Usuário';
                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      name = userData['displayName'] ?? userData['name'] ?? name;
                    }
                    return _buildAuthorRow(name, theme, isLiked, likedBy.length, currentUid, likedBy);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorRow(String name, ThemeData theme, bool isLiked, int likeCount, String currentUid, List likedBy) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: theme.primaryColor,
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 12, color: Colors.white)),
        ),
        const SizedBox(width: 8),
        Text(name, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        
        // --- BOTÃO DE CURTIR ---
        GestureDetector(
          onTap: currentUid.isEmpty ? null : () => _toggleLike(currentUid, likedBy),
          child: Row(
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text('$likeCount', style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey),
        const SizedBox(width: 4),
        const Text('Ver', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}