/// Modèles de données pour l'API CSS RAG Multimodal

/// Énumération des providers API disponibles
enum ApiProvider {
  mistral,
  openai,
  anthropic,
  deepseek,
  groq,
}

/// Extension pour convertir ApiProvider en string
extension ApiProviderExtension on ApiProvider {
  String get value {
    switch (this) {
      case ApiProvider.mistral:
        return 'mistral';
      case ApiProvider.openai:
        return 'openai';
      case ApiProvider.anthropic:
        return 'anthropic';
      case ApiProvider.deepseek:
        return 'deepseek';
      case ApiProvider.groq:
        return 'groq';
    }
  }
}

/// Énumération des types de contenu
enum ContentType {
  document,
  image,
}

/// Extension pour convertir ContentType en string
extension ContentTypeExtension on ContentType {
  String get value {
    switch (this) {
      case ContentType.document:
        return 'document';
      case ContentType.image:
        return 'image';
    }
  }
}

/// Énumération des endpoints API
enum ApiEndpoint {
  askMultimodal,
  askQuestionUltra,
  askQuestionStreamUltra,
}

/// Extension pour convertir ApiEndpoint en path
extension ApiEndpointExtension on ApiEndpoint {
  String get path {
    switch (this) {
      case ApiEndpoint.askMultimodal:
        return '/ask-multimodal-question';
      case ApiEndpoint.askQuestionUltra:
        return '/ask-question-ultra';
      case ApiEndpoint.askQuestionStreamUltra:
        return '/ask-question-stream-ultra';
    }
  }
}

/// Modèle pour les requêtes multimodales
class MultimodalQuestionRequest {
  final String question;
  final ApiProvider provider;
  final List<ContentType> contentTypes;
  final bool includeImages;
  final int? topK;
  final double? threshold;
  final bool? useHybridSearch;
  final String? imageQuery;

  const MultimodalQuestionRequest({
    required this.question,
    required this.provider,
    required this.contentTypes,
    required this.includeImages,
    this.topK,
    this.threshold,
    this.useHybridSearch,
    this.imageQuery,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'provider': provider.value,
      'content_types': contentTypes.map((e) => e.value).toList(),
      'include_images': includeImages,
      if (topK != null) 'top_k': topK,
      if (threshold != null) 'threshold': threshold,
      if (useHybridSearch != null) 'use_hybrid_search': useHybridSearch,
      if (imageQuery != null) 'image_query': imageQuery,
    };
  }

  factory MultimodalQuestionRequest.fromJson(Map<String, dynamic> json) {
    return MultimodalQuestionRequest(
      question: json['question'] as String,
      provider: ApiProvider.values.firstWhere(
        (e) => e.value == json['provider'],
      ),
      contentTypes: (json['content_types'] as List)
          .map((e) => ContentType.values.firstWhere(
                (ct) => ct.value == e,
              ))
          .toList(),
      includeImages: json['include_images'] as bool,
      topK: json['top_k'] as int?,
      threshold: json['threshold'] as double?,
      useHybridSearch: json['use_hybrid_search'] as bool?,
      imageQuery: json['image_query'] as String?,
    );
  }
}

/// Modèle pour les requêtes simples
class QuestionRequest {
  final String question;
  final ApiProvider provider;
  final int? topK;
  final double? threshold;

  const QuestionRequest({
    required this.question,
    required this.provider,
    this.topK,
    this.threshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'provider': provider.value,
      if (topK != null) 'top_k': topK,
      if (threshold != null) 'threshold': threshold,
    };
  }

  factory QuestionRequest.fromJson(Map<String, dynamic> json) {
    return QuestionRequest(
      question: json['question'] as String,
      provider: ApiProvider.values.firstWhere(
        (e) => e.value == json['provider'],
      ),
      topK: json['top_k'] as int?,
      threshold: json['threshold'] as double?,
    );
  }
}

/// Modèle pour les sources de réponse selon l'API réelle
class ResponseSource {
  final int sourceId;
  final double score;
  final int originalRank;
  final Map<String, dynamic> metadata;

  const ResponseSource({
    required this.sourceId,
    required this.score,
    required this.originalRank,
    required this.metadata,
  });

  factory ResponseSource.fromJson(Map<String, dynamic> json) {
    return ResponseSource(
      sourceId: json['source_id'] as int? ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      originalRank: json['original_rank'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_id': sourceId,
      'score': score,
      'original_rank': originalRank,
      'metadata': metadata,
    };
  }
}

/// Modèle pour les métriques de réponse
class ResponseMetrics {
  final double responseTime;
  final int totalSources;
  final String model;

  const ResponseMetrics({
    required this.responseTime,
    required this.totalSources,
    required this.model,
  });

  factory ResponseMetrics.fromJson(Map<String, dynamic> json) {
    return ResponseMetrics(
      responseTime: json['response_time'] as double,
      totalSources: json['total_sources'] as int,
      model: json['model'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_time': responseTime,
      'total_sources': totalSources,
      'model': model,
    };
  }
}

/// Modèle pour les réponses avancées selon l'openapi.json
class AdvancedQuestionResponse {
  final String id;
  final String answer;
  final bool contextFound;
  final String providerUsed;
  final String modelUsed;
  final double responseTimeMs;
  final String timestamp;
  final int searchResults;
  final int rankedResults;
  final List<String> enhancedQueries;
  final List<ResponseSource> sources;
  final Map<String, dynamic> performanceMetrics;

  const AdvancedQuestionResponse({
    required this.id,
    required this.answer,
    required this.contextFound,
    required this.providerUsed,
    required this.modelUsed,
    required this.responseTimeMs,
    required this.timestamp,
    required this.searchResults,
    required this.rankedResults,
    required this.enhancedQueries,
    required this.sources,
    required this.performanceMetrics,
  });

  factory AdvancedQuestionResponse.fromJson(Map<String, dynamic> json) {
    return AdvancedQuestionResponse(
      id: json['id'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      contextFound: json['context_found'] as bool? ?? false,
      providerUsed: json['provider_used'] as String? ?? '',
      modelUsed: json['model_used'] as String? ?? '',
      responseTimeMs: (json['response_time_ms'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] as String? ?? '',
      searchResults: json['search_results'] as int? ?? 0,
      rankedResults: json['ranked_results'] as int? ?? 0,
      enhancedQueries: (json['enhanced_queries'] as List?)?.cast<String>() ?? [],
      sources: (json['sources'] as List?)
          ?.map((e) => ResponseSource.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      performanceMetrics: json['performance_metrics'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,
      'context_found': contextFound,
      'provider_used': providerUsed,
      'model_used': modelUsed,
      'response_time_ms': responseTimeMs,
      'timestamp': timestamp,
      'search_results': searchResults,
      'ranked_results': rankedResults,
      'enhanced_queries': enhancedQueries,
      'sources': sources.map((e) => e.toJson()).toList(),
      'performance_metrics': performanceMetrics,
    };
  }
}