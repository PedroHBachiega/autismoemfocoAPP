import 'dart:io' show Platform; // Necessário para checar Windows
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  Map<String, dynamic>? _userProfile;
  bool _loading = true;
  bool _actionLoading = false;
  String? _error;

  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get loading => _loading;
  bool get actionLoading => _actionLoading;
  String? get error => _error;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      await _fetchUserProfile(user.uid);
    } else {
      _userProfile = null;
    }
    _loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> _fetchUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userProfile = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      } else {
        _userProfile = null;
      }
      return _userProfile;
    } catch (e) {
      debugPrint("Erro ao buscar perfil: $e");
      _userProfile = null;
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    _actionLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final profile = await _fetchUserProfile(cred.user!.uid);
      
      if (profile == null) {
        await _createInitialProfile(cred.user!);
        await _fetchUserProfile(cred.user!.uid);
      }
      _actionLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = "Email ou senha inválidos.";
      _actionLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// IMPLEMENTAÇÃO DO LOGIN COM GOOGLE
  Future<bool> loginWithGoogle() async {
  _actionLoading = true;
  _error = null;
  notifyListeners();

    try {
      if (!kIsWeb && Platform.isWindows) {
        _error = "O login com Google não é compatível com Windows.";
        _actionLoading = false;
        notifyListeners();
        return false;
      }

      await _googleSignIn.initialize(
        serverClientId: '241125743479-licc615o5efem7rfhqo92ik4ki5b94gs.apps.googleusercontent.com',
      );
                      
      // NESSA VERSÃO (7.2.0) O COMANDO É .authenticate()
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      
      if (googleUser == null) {
        _actionLoading = false;
        notifyListeners();
        return false;
      }

      // O resto continua igual...
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential cred = await _auth.signInWithCredential(credential);
      final User user = cred.user!;

      final profile = await _fetchUserProfile(user.uid);
      if (profile == null) {
        await _createInitialProfile(user);
        await _fetchUserProfile(user.uid);
      }

      _actionLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      print("================ ERRO REAL DO GOOGLE ================");
      print(e.toString()); 
      _error = "Falha no login com Google: $e";
      _actionLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _createInitialProfile(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? "",
      'cidade': "",
      'estado': "",
      'telefone': "",
      'bio': "",
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() async {
    // Agora desloga de ambos para permitir trocar de conta Google depois
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    _userProfile = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _actionLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _actionLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'user-not-found':
          _error = "Email não encontrado.";
          break;
        case 'invalid-email':
          _error = "Email inválido.";
          break;
        default:
          _error = "Erro ao enviar email de redefinição.";
      }
      _actionLoading = false;
      notifyListeners();
      return false;
    } catch (err) {
      _error = "Erro inesperado.";
      _actionLoading = false;
      notifyListeners();
      return false;
    }
  }
}