import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;
  
  // 1. Criamos uma variável para guardar o Future do post
  late Future<DocumentSnapshot> _postFuture;

  @override
  void initState() {
    super.initState();
    // 2. Iniciamos a busca do post apenas UMA vez aqui
    _postFuture = FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
  }

  Future<void> _sendComment(AuthProvider auth) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'userId': auth.user?.uid,
        'authorName': auth.userProfile?['displayName'] ?? 'Usuário',
        'content': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _commentController.clear();
      FocusScope.of(context).unfocus();
      // Removi o unfocus para o teclado não fechar forçado
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao comentar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _deleteComment(String commentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir comentário?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').doc(commentId).delete();
    }
  }

  Future<void> _editComment(String commentId, String currentText) async {
    final controller = TextEditingController(text: currentText);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar comentário'),
        content: TextField(controller: controller, maxLines: null, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').doc(commentId).update({'content': controller.text.trim()});
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Post')),
      body: FutureBuilder<DocumentSnapshot>(
        future: _postFuture, // 3. Usamos a variável fixa, não o comando de busca direto
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Erro: ${snapshot.error}'));
          if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: Text('Post não encontrado.'));

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String title = data['title'] ?? 'Sem Título';
          final String content = data['content'] ?? '';
          final String category = data['category'] ?? 'Geral';
          final Timestamp? createdAt = data['createdAt'] as Timestamp?;
          final String authorName = data['authorName'] ?? 'Anônimo';

          String timeAgo = createdAt != null ? timeago.format(createdAt.toDate(), locale: 'pt_BR') : '';

          Color catColor = theme.primaryColor;
          if (category == 'Dúvidas') catColor = Colors.orange;
          else if (category == 'Conquistas') catColor = Colors.green;
          else if (category == 'Desabafos') catColor = Colors.purple;
          else if (category == 'Inclusão') catColor = Colors.blue;
          else if (category == 'Direitos') catColor = Colors.red;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: catColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: catColor.withOpacity(0.5))),
                            child: Text(category, style: TextStyle(color: catColor, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          Text(timeAgo, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(radius: 16, backgroundColor: theme.primaryColor, child: Text(authorName.isNotEmpty ? authorName[0].toUpperCase() : '?', style: const TextStyle(fontSize: 14, color: Colors.white))),
                          const SizedBox(width: 8),
                          Text(authorName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(content, style: const TextStyle(fontSize: 16, height: 1.6)),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text('Comentários', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').orderBy('createdAt', descending: true).snapshots(),
                        builder: (context, commentSnapshot) {
                          if (!commentSnapshot.hasData || commentSnapshot.data!.docs.isEmpty) {
                            return const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('Nenhum comentário ainda.', style: TextStyle(color: Colors.grey)));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: commentSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var doc = commentSnapshot.data!.docs[index];
                              var cData = doc.data() as Map<String, dynamic>;
                              bool isMine = authProvider.user?.uid == (cData['userId'] ?? '');
                              
                              DateTime date = cData['createdAt'] != null ? (cData['createdAt'] as Timestamp).toDate() : DateTime.now();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(cData['authorName'] ?? 'Usuário', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(width: 8),
                                      Text(timeago.format(date, locale: 'pt_BR'), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                      const Spacer(),
                                      if (isMine) ...[
                                        IconButton(icon: const Icon(Icons.edit, size: 18, color: Colors.blue), onPressed: () => _editComment(doc.id, cData['content'] ?? '')),
                                        IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () => _deleteComment(doc.id)),
                                      ]
                                    ],
                                  ),
                                  Text(cData['content'] ?? '', style: const TextStyle(fontSize: 15)),
                                  const Divider(),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (authProvider.user != null)
                Container(
                  padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: MediaQuery.of(context).viewInsets.bottom + 8),
                  decoration: BoxDecoration(color: theme.cardColor, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))]),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          maxLines: null,
                          decoration: const InputDecoration(hintText: 'Comentar...', border: InputBorder.none),
                        ),
                      ),
                      _isSending
                          ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                          : IconButton(
                              icon: Icon(Icons.send, color: theme.primaryColor),
                              onPressed: () => _sendComment(authProvider),
                            ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}