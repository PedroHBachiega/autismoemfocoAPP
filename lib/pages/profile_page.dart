import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  bool _isEditing = false;
  bool _isSaving = false;

  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AuthProvider>().userProfile;
    _nameController = TextEditingController(text: profile?['displayName'] ?? '');
    _bioController = TextEditingController(text: profile?['bio'] ?? '');
    _cidadeController = TextEditingController(text: profile?['cidade'] ?? '');
    _estadoController = TextEditingController(text: profile?['estado'] ?? '');
    _telefoneController = TextEditingController(text: profile?['telefone'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'displayName': _nameController.text,
          'bio': _bioController.text,
          'cidade': _cidadeController.text,
          'estado': _estadoController.text,
          'telefone': _telefoneController.text,
        });

        // Inform provider to refresh data (we can just call logout/login or a specific refresh method, 
        // to simplify we just show a snackbar and let the next auth state change or manual refresh handle it)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso!'), backgroundColor: Colors.green),
          );
          setState(() => _isEditing = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final theme = Theme.of(context);

    if (user == null) {
      return const Center(child: Text('Usuário não logado.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Editar Perfil',
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                _isEditing = false;
                // Revert changes
                final profile = authProvider.userProfile;
                _nameController.text = profile?['displayName'] ?? '';
                _bioController.text = profile?['bio'] ?? '';
                _cidadeController.text = profile?['cidade'] ?? '';
                _estadoController.text = profile?['estado'] ?? '';
                _telefoneController.text = profile?['telefone'] ?? '';
              }),
              tooltip: 'Cancelar',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.primaryColor,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null
                        ? Text(
                            user.displayName?.isNotEmpty == true ? user.displayName![0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 40, color: Colors.white),
                          )
                        : null,
                  ),
                  if (_isEditing)
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.secondary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: () {
                          // TODO: Implement image picker for profile photo
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Alteração de foto ainda não implementada.')),
                          );
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.email ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informações Pessoais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nome de Exibição', border: OutlineInputBorder()),
                        enabled: _isEditing,
                        validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(labelText: 'Bio / Sobre mim', border: OutlineInputBorder()),
                        enabled: _isEditing,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _cidadeController,
                              decoration: const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()),
                              enabled: _isEditing,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _estadoController,
                              decoration: const InputDecoration(labelText: 'Estado (UF)', border: OutlineInputBorder()),
                              enabled: _isEditing,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telefoneController,
                        decoration: const InputDecoration(labelText: 'Telefone', border: OutlineInputBorder()),
                        enabled: _isEditing,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveProfile,
                  icon: _isSaving ? const SizedBox.shrink() : const Icon(Icons.save),
                  label: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar Alterações'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
