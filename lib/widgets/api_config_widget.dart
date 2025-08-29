import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/api_models.dart';
import '../providers/chat_provider.dart';

/// Widget pour configurer l'API (endpoint et provider)
class ApiConfigWidget extends StatelessWidget {
  const ApiConfigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Configuration API',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Sélection de l'endpoint
                Text(
                  'Endpoint:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ApiEndpoint>(
                  value: chatProvider.currentEndpoint,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: ApiEndpoint.values.map((endpoint) {
                    return DropdownMenuItem(
                      value: endpoint,
                      child: Text(_getEndpointDisplayName(endpoint)),
                    );
                  }).toList(),
                  onChanged: chatProvider.isLoading
                      ? null
                      : (ApiEndpoint? newEndpoint) {
                          if (newEndpoint != null) {
                            chatProvider.setApiEndpoint(newEndpoint);
                          }
                        },
                ),
                const SizedBox(height: 16),
                
                // Sélection du provider
                Text(
                  'Provider:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ApiProvider>(
                  value: chatProvider.currentProvider,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: ApiProvider.values.map((provider) {
                    return DropdownMenuItem(
                      value: provider,
                      child: Text(_getProviderDisplayName(provider)),
                    );
                  }).toList(),
                  onChanged: chatProvider.isLoading
                      ? null
                      : (ApiProvider? newProvider) {
                          if (newProvider != null) {
                            chatProvider.setApiProvider(newProvider);
                          }
                        },
                ),
                const SizedBox(height: 16),
                
                // Bouton de test de connexion
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: chatProvider.isLoading
                        ? null
                        : () => _testConnection(context, chatProvider),
                    icon: const Icon(Icons.wifi_find),
                    label: const Text('Tester la connexion'),
                  ),
                ),
                
                // Informations sur la configuration actuelle
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuration actuelle:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Endpoint: ${_getEndpointDisplayName(chatProvider.currentEndpoint)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Provider: ${_getProviderDisplayName(chatProvider.currentProvider)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Content Types: [document]',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Include Images: false',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getEndpointDisplayName(ApiEndpoint endpoint) {
    switch (endpoint) {
      case ApiEndpoint.askMultimodal:
        return 'Ask Multimodal Question';
      case ApiEndpoint.askQuestionUltra:
        return 'Ask Question Ultra';
      case ApiEndpoint.askQuestionStreamUltra:
        return 'Ask Question Stream Ultra';
      default:
        return 'Unknown Endpoint';
    }
  }

  String _getProviderDisplayName(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.mistral:
        return 'Mistral';
      case ApiProvider.openai:
        return 'OpenAI';
      case ApiProvider.anthropic:
        return 'Anthropic';
      case ApiProvider.deepseek:
        return 'DeepSeek';
      case ApiProvider.groq:
        return 'Groq';
      default:
        return 'Unknown Provider';
    }
  }

  Future<void> _testConnection(BuildContext context, ChatProvider chatProvider) async {
    try {
      final isConnected = await chatProvider.testApiConnection();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isConnected ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected
                      ? 'Connexion réussie !'
                      : 'Échec de la connexion',
                ),
              ],
            ),
            backgroundColor: isConnected ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Erreur: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}