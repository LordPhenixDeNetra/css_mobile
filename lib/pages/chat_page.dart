import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/chat_provider.dart';
import '../widgets/api_config_widget.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const _ChatPageContent(),
    );
  }
}

class _ChatPageContent extends StatefulWidget {
  const _ChatPageContent();

  @override
  State<_ChatPageContent> createState() => _ChatPageContentState();
}

class _ChatPageContentState extends State<_ChatPageContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();



  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Masquer le clavier
    FocusScope.of(context).unfocus();
    
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(text);
    _messageController.clear();
    _scrollToBottom();
  }



  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showApiConfigDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 600,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header du dialog
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Configuration API',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Contenu du dialog
                const Flexible(
                  child: SingleChildScrollView(
                    child: ApiConfigWidget(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            title: const Row(
              children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant CSS IPRES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'En ligne',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showApiConfigDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Menu d'options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Indicateur d'erreur
          if (chatProvider.error != null)
            _buildErrorBanner(chatProvider, isDark),
          // Liste des messages
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                itemCount: chatProvider.messages.length + (chatProvider.isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == chatProvider.messages.length && chatProvider.isTyping) {
                    return _buildTypingIndicator(isDark);
                  }
                  return _buildMessageBubble(chatProvider.messages[index], isDark);
                },
              ),
            ),
          ),
          // Champ de saisie
          _buildMessageInput(theme, isDark, chatProvider.isLoading),
        ],
      ),
    );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                minWidth: 120,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor
                    : isDark
                        ? const Color(0xFF2D2D2D)
                        : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownBody(
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : isDark
                                ? Colors.white
                                : Colors.black87,
                        fontSize: 15,
                        height: 1.4,
                      ),
                      strong: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : isDark
                                ? Colors.white
                                : Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      em: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : isDark
                                ? Colors.white
                                : Colors.black87,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                      code: TextStyle(
                        color: message.isUser
                            ? Colors.white70
                            : isDark
                                ? Colors.grey[300]
                                : Colors.grey[700],
                        fontSize: 14,
                        fontFamily: 'monospace',
                        backgroundColor: message.isUser
                            ? Colors.white.withOpacity(0.1)
                            : isDark
                                ? Colors.grey[800]
                                : Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white70
                          : isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -4 * (0.5 - (value - 0.5).abs()) * 2),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorBanner(ChatProvider chatProvider, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              chatProvider.error!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            onPressed: () => chatProvider.clearError(),
            icon: Icon(
              Icons.close,
              color: Colors.red,
              size: 18,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ThemeData theme, bool isDark, bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF3D3D3D) : Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? const Color(0xFF3D3D3D) : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Tapez votre message...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: isLoading ? Colors.grey : theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: isLoading ? null : _sendMessage,
                icon: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
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
}