import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class CriarPostPage extends StatefulWidget {
  const CriarPostPage({super.key});

  @override
  State<CriarPostPage> createState() => _CriarPostPageState();
}

class _CriarPostPageState extends State<CriarPostPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _category = 'Dúvidas'; // Default category
  bool _isLoading = false;

  final List<String> _categories = [
    'Dúvidas',
    'Conquistas',
    'Desabafos',
    'Inclusão',
    'Direitos',
    'Geral'
  ];

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final user = context.read<AuthProvider>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado para publicar.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'title': _title,
        'content': _content,
        'category': _category,
        'uid': user.uid,
        'authorId': user.uid,
        'authorName': user.displayName ?? 'Usuário Anônimo',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post criado com sucesso!'), backgroundColor: Colors.green),
        );
        context.pop(); // Go back to community page
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar post: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Novo Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título do Post',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Dúvida sobre direitos escolares',
                ),
                validator: (value) => value == null || value.isEmpty ? 'Título é obrigatório' : null,
                onSaved: (v) => _title = v!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Conteúdo',
                  border: OutlineInputBorder(),
                  hintText: 'Escreva seu relato, dúvida ou desabafo aqui...',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) => value == null || value.isEmpty ? 'Conteúdo não pode ser vazio' : null,
                onSaved: (v) => _content = v!,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Publicar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
