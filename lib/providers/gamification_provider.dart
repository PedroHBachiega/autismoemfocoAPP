import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GamificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  int _points = 0;
  int _level = 1;
  List<Map<String, dynamic>> _badges = [];
  Map<String, int> _actionHistory = {};

  int get points => _points;
  int get level => _level;
  List<Map<String, dynamic>> get badges => _badges;
  Map<String, int> get actionHistory => _actionHistory;

  final Map<String, int> _pointsConfig = {
    'create_post': 10,
    'comment': 5,
    'like_post': 2,
    'daily_login': 15,
  };

  GamificationProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _resetData();
      }
    });
  }

  void _resetData() {
    _points = 0;
    _level = 1;
    _badges = [];
    _actionHistory = {};
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('gamification').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _points = data['points'] ?? 0;
        _level = _calculateLevel(_points);
        _badges = List<Map<String, dynamic>>.from(data['badges'] ?? []);
        _actionHistory = Map<String, int>.from(data['actionHistory'] ?? {});
      } else {
        // Initialize if doesn't exist
        await _firestore.collection('gamification').doc(uid).set({
          'points': 0,
          'badges': [],
          'actionHistory': {},
        });
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao carregar gamificação: $e");
    }
  }

  int _calculateLevel(int totalPoints) {
    return (totalPoints / 100).floor() + 1;
  }

  Future<void> addPoints(String actionType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final pointsToAdd = _pointsConfig[actionType] ?? 0;
    if (pointsToAdd == 0) return;

    try {
      final docRef = _firestore.collection('gamification').doc(user.uid);
      
      // We read current state first in a transaction
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) return;

        Map<String, dynamic> data = snapshot.data()!;
        int currentPoints = data['points'] ?? 0;
        Map<String, int> history = Map<String, int>.from(data['actionHistory'] ?? {});
        List<Map<String, dynamic>> currentBadges = List<Map<String, dynamic>>.from(data['badges'] ?? []);

        int newPoints = currentPoints + pointsToAdd;
        history[actionType] = (history[actionType] ?? 0) + 1;

        // Check for new badges based on updated history
        final newBadges = _checkNewBadges(history, currentBadges);
        if (newBadges.isNotEmpty) {
          currentBadges.addAll(newBadges);
        }

        transaction.update(docRef, {
          'points': newPoints,
          'actionHistory': history,
          'badges': currentBadges,
        });
      });
      
      // Reload updated data
      await _loadUserData(user.uid);

    } catch (e) {
      debugPrint("Erro ao adicionar pontos: $e");
    }
  }

  List<Map<String, dynamic>> _checkNewBadges(Map<String, int> history, List<Map<String, dynamic>> currentBadges) {
    List<Map<String, dynamic>> earned = [];
    final currentBadgeIds = currentBadges.map((b) => b['id']).toSet();

    // Replicate badges config
    final configBadges = [
      {'id': 'iniciante', 'name': 'Comunidador Iniciante', 'condition': 'create_post', 'count': 1, 'icon': '🌟'},
      {'id': 'ativo', 'name': 'Membro Ativo', 'condition': 'comment', 'count': 10, 'icon': '🔥'},
      {'id': 'engajado', 'name': 'Engajado', 'condition': 'like_post', 'count': 20, 'icon': '❤️'},
    ];

    for (var badge in configBadges) {
      if (!currentBadgeIds.contains(badge['id'])) {
        final actionCount = history[badge['condition']] ?? 0;
        if (actionCount >= (badge['count'] as int)) {
          earned.add({
            'id': badge['id'],
            'name': badge['name'],
            'icon': badge['icon'],
            'earnedAt': DateTime.now().toIso8601String(),
          });
        }
      }
    }
    return earned;
  }
}
