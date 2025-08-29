import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  // Données simulées de l'utilisateur
  final Map<String, dynamic> _userData = {
    'nom': 'Amadou DIALLO',
    'numeroAdhesion': '123456789',
    'dernierePaie': '15/12/2023',
    'cotisationsAJour': true,
  };

  // Statistiques rapides
  final Map<String, dynamic> _stats = {
    'totalCotisations': 540000,
    'prestationsRecues': 3,
    'documentsDisponibles': 12,
    'notificationsNonLues': 2,
  };

  // État des animations
  bool _animationsInitialized = false;

  // Getters
  Map<String, dynamic> get userData => _userData;
  Map<String, dynamic> get stats => _stats;
  bool get animationsInitialized => _animationsInitialized;

  // Méthodes pour gérer les données utilisateur
  void updateUserData(String key, dynamic value) {
    _userData[key] = value;
    notifyListeners();
  }

  // Méthodes pour gérer les statistiques
  void updateStats(String key, dynamic value) {
    _stats[key] = value;
    notifyListeners();
  }

  void incrementNotifications() {
    _stats['notificationsNonLues'] = (_stats['notificationsNonLues'] ?? 0) + 1;
    notifyListeners();
  }

  void clearNotifications() {
    _stats['notificationsNonLues'] = 0;
    notifyListeners();
  }

  // Méthodes pour les animations
  void initializeAnimations() {
    _animationsInitialized = true;
    notifyListeners();
  }

  void resetAnimations() {
    _animationsInitialized = false;
    notifyListeners();
  }

  // Méthodes utilitaires
  String formatCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} FCFA';
  }

  String getUserDisplayName() {
    return _userData['nom'] ?? 'Utilisateur';
  }

  String getUserMembershipNumber() {
    return _userData['numeroAdhesion'] ?? 'N/A';
  }

  bool isUserUpToDate() {
    return _userData['cotisationsAJour'] ?? false;
  }

  int getUnreadNotificationsCount() {
    return _stats['notificationsNonLues'] ?? 0;
  }

  // Simulation de chargement de données
  Future<void> loadUserData() async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mise à jour des données (simulation)
    _userData['dernierePaie'] = DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0];
    _stats['totalCotisations'] = 540000 + (DateTime.now().millisecondsSinceEpoch % 10000);
    
    notifyListeners();
  }

  Future<void> refreshData() async {
    await loadUserData();
  }
}