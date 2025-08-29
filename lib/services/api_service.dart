import 'dart:io';
import 'package:dio/dio.dart';
import '../models/api_models.dart';

/// Configuration de l'API
class ApiConfig {
  static const String baseUrl = 'http://192.168.1.90:8000';
  static const Duration timeout = Duration(seconds: 30);
  
  // Configuration par défaut pour l'endpoint multimodal
  static const ApiEndpoint defaultEndpoint = ApiEndpoint.askMultimodal;
  static const ApiProvider defaultProvider = ApiProvider.deepseek;
  static const List<ContentType> defaultContentTypes = [ContentType.document];
  static const bool defaultIncludeImages = false;
}

/// Service pour gérer les appels API
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  late final Dio _dio;
  
  // Configuration actuelle de l'endpoint
  ApiEndpoint _currentEndpoint = ApiConfig.defaultEndpoint;
  ApiProvider _currentProvider = ApiConfig.defaultProvider;
  
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      sendTimeout: ApiConfig.timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Ajouter des intercepteurs pour le logging (optionnel)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }
  
  /// Getters pour la configuration actuelle
  ApiEndpoint get currentEndpoint => _currentEndpoint;
  ApiProvider get currentProvider => _currentProvider;
  
  /// Méthodes pour changer la configuration
  void setEndpoint(ApiEndpoint endpoint) {
    _currentEndpoint = endpoint;
  }
  
  void setProvider(ApiProvider provider) {
    _currentProvider = provider;
  }
  
  void setConfiguration({
    ApiEndpoint? endpoint,
    ApiProvider? provider,
  }) {
    if (endpoint != null) _currentEndpoint = endpoint;
    if (provider != null) _currentProvider = provider;
  }

  /// Méthode principale pour poser une question
  Future<AdvancedQuestionResponse> askQuestion({
    required String question,
    ApiEndpoint? endpoint,
    ApiProvider? provider,
    List<ContentType>? contentTypes,
    bool? includeImages,
    int? topK,
    double? threshold,
    bool? useHybridSearch,
    String? imageQuery,
  }) async {
    final useEndpoint = endpoint ?? _currentEndpoint;
    final useProvider = provider ?? _currentProvider;
    
    switch (useEndpoint) {
      case ApiEndpoint.askMultimodal:
        return await _askMultimodalQuestion(
          question: question,
          provider: useProvider,
          contentTypes: contentTypes ?? ApiConfig.defaultContentTypes,
          includeImages: includeImages ?? ApiConfig.defaultIncludeImages,
          topK: topK,
          threshold: threshold,
          useHybridSearch: useHybridSearch,
          imageQuery: imageQuery,
        );
      
      case ApiEndpoint.askQuestionUltra:
        return await _askQuestionUltra(
          question: question,
          provider: useProvider,
          topK: topK,
          threshold: threshold,
        );
      
      case ApiEndpoint.askQuestionStreamUltra:
        // Pour le streaming, on retourne une réponse simple pour l'instant
        // TODO: Implémenter le streaming avec des callbacks
        return await _askQuestionUltra(
          question: question,
          provider: useProvider,
          topK: topK,
          threshold: threshold,
        );
    }
  }

  /// Appel à l'endpoint multimodal
  Future<AdvancedQuestionResponse> _askMultimodalQuestion({
    required String question,
    required ApiProvider provider,
    required List<ContentType> contentTypes,
    required bool includeImages,
    int? topK,
    double? threshold,
    bool? useHybridSearch,
    String? imageQuery,
  }) async {
    final request = MultimodalQuestionRequest(
      question: question,
      provider: provider,
      contentTypes: contentTypes,
      includeImages: includeImages,
      topK: topK,
      threshold: threshold,
      useHybridSearch: useHybridSearch,
      imageQuery: imageQuery,
    );

    return await _makeRequest(
      endpoint: ApiEndpoint.askMultimodal.path,
      body: request.toJson(),
    );
  }

  /// Appel à l'endpoint question ultra
  Future<AdvancedQuestionResponse> _askQuestionUltra({
    required String question,
    required ApiProvider provider,
    int? topK,
    double? threshold,
  }) async {
    final request = QuestionRequest(
      question: question,
      provider: provider,
      topK: topK,
      threshold: threshold,
    );

    return await _makeRequest(
      endpoint: ApiEndpoint.askQuestionUltra.path,
      body: request.toJson(),
    );
  }

  /// Méthode générique pour faire les requêtes HTTP avec Dio
  Future<AdvancedQuestionResponse> _makeRequest({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        return AdvancedQuestionResponse.fromJson(jsonData);
      } else {
        final errorData = response.data as Map<String, dynamic>? ?? {};
        throw Exception(errorData['message'] ?? 'Erreur HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Délai d\'attente dépassé. Vérifiez votre connexion internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
      } else if (e.response != null) {
        final errorData = e.response?.data as Map<String, dynamic>? ?? {};
        throw Exception(errorData['message'] ?? 'Erreur HTTP ${e.response?.statusCode}');
      } else {
        throw Exception('Erreur de réseau: ${e.message}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur inattendue: ${e.toString()}');
    }
  }

  /// Méthode pour tester la connexion à l'API
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get(
        '/health',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Méthode pour obtenir les informations sur les capacités multimodales
  Future<Map<String, dynamic>?> getMultimodalCapabilities() async {
    try {
      final response = await _dio.get('/multimodal-capabilities');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Nettoyage des ressources
  void dispose() {
    _dio.close();
  }
}