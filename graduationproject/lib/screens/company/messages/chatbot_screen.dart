import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/company_store.dart';
import '../../../../data/models/chat/chatbot_message.dart';
import '../../../../data/services/chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final ChatbotService _chatbotService;

  List<ChatbotMessage> _history = [];
  bool _isLoading = true;
  bool _isTyping = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _chatbotService = ChatbotService(ApiClient());
    _loadHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final userId = CompanyStore.instance.companyId;
    if (userId == null) return;
    try {
      final history = await _chatbotService.getAiChatbotHistory(userId);
      if (mounted) {
        setState(() {
          _history = history.reversed.toList();
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _sendMessage([String? quickAction]) async {
    final text = quickAction ?? _messageController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    final userId = CompanyStore.instance.companyId ?? 'unknown';
    _messageController.clear();

    // Create a temporary message representing the user's input
    final tempMsg = ChatbotMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: text,
      response: '', // Empty initially
      timestamp: DateTime.now(),
      userId: userId,
    );

    setState(() {
      _history.add(tempMsg);
      _isTyping = true;
    });
    _scrollToBottom();

    final imageToSend = _selectedImage;
    setState(() => _selectedImage = null);

    try {
      final response = await _chatbotService.askAiChatbot(
        text,
        userId: userId,
        image: imageToSend,
      );

      if (mounted) {
        setState(() {
          // Replace the temporary message with the actual response
          final index = _history.indexWhere((m) => m.id == tempMsg.id);
          if (index != -1) {
            _history[index] = ChatbotMessage(
              id: tempMsg.id,
              message: text,
              response: response,
              timestamp: tempMsg.timestamp,
              userId: userId,
            );
          }
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to get response')));
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.smart_toy_outlined, color: cs.primary),
            ),
            const SizedBox(width: 12),
            Text(t.tr(en: 'AI Assistant', ar: 'المساعد الذكي')),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick actions
          if (_history.isEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickAction(
                    t.tr(en: 'Write a job post', ar: 'اكتب إعلان وظيفة'),
                  ),
                  _buildQuickAction(
                    t.tr(en: 'Interview questions', ar: 'أسئلة مقابلة'),
                  ),
                  _buildQuickAction(
                    t.tr(en: 'Evaluate a CV', ar: 'تقييم سيرة ذاتية'),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final msg = _history[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (msg.message.isNotEmpty)
                            _buildMessageBubble(msg.message, true),
                          if (msg.response.isNotEmpty)
                            _buildMessageBubble(msg.response, false),
                        ],
                      );
                    },
                  ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.smart_toy, size: 16, color: cs.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t.tr(en: 'Typing...', ar: 'يكتب...'),
                    style: TextStyle(color: cs.onSurface.withOpacity(0.5)),
                  ),
                ],
              ),
            ),

          if (_selectedImage != null)
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              border: Border(top: BorderSide(color: cs.outlineVariant)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image_outlined, color: cs.primary),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: t.tr(
                        en: 'Ask me anything...',
                        ar: 'اسألني أي شيء...',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: cs.primary,
                  child: IconButton(
                    onPressed: () => _sendMessage(),
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String text) {
    final cs = Theme.of(context).colorScheme;
    return ActionChip(
      label: Text(text),
      backgroundColor: cs.primaryContainer.withOpacity(0.5),
      labelStyle: TextStyle(color: cs.primary, fontSize: 12),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () => _sendMessage(text),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? cs.onPrimary : cs.onSurface),
        ),
      ),
    );
  }
}
