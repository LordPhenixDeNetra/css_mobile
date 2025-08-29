import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ApiEndpoint get currentEndpoint => _apiService.currentEndpoint;
  ApiProvider get currentProvider => _apiService.currentProvider;

  ChatProvider() {
    _addWelcomeMessages();
  }

  void _addWelcomeMessages() {
    _messages.addAll([
      ChatMessage(
        text: "Bonjour ! Je suis votre assistant CSS IPRES. Comment puis-je vous aider aujourd'hui ?",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        text: "Vous pouvez me poser des questions sur vos cotisations, prestations, documents ou toute autre information concernant votre compte CSS IPRES.",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
    ]);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Ajouter le message de l'utilisateur
    _messages.add(ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    ));
    
    // Activer l'indicateur de frappe
    _isTyping = true;
    notifyListeners();

    // Envoyer la requête à l'API
    _sendApiRequest(text.trim());
  }

  Future<void> _sendApiRequest(String userMessage) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.askQuestion(
        question: userMessage,
        contentTypes: [ContentType.document],
        includeImages: false,
      );

      _messages.add(ChatMessage(
        text: response.answer,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _error = 'Erreur lors de l\'envoi du message: ${e.toString()}';
      // Ajouter un message d'erreur pour l'utilisateur
      _messages.add(ChatMessage(
        text: 'Désolé, une erreur s\'est produite. Veuillez réessayer.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isTyping = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Méthodes pour configurer l'API
  void setApiEndpoint(ApiEndpoint endpoint) {
    _apiService.setEndpoint(endpoint);
    notifyListeners();
  }

  void setApiProvider(ApiProvider provider) {
    _apiService.setProvider(provider);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    _addWelcomeMessages();
    notifyListeners();
  }

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Test de connexion API
  Future<bool> testApiConnection() async {
    try {
      return await _apiService.testConnection();
    } catch (e) {
      _error = 'Erreur de connexion: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}