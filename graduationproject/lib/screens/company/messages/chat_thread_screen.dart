import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../data/services/chat_service.dart';
import '../../../core/network/api_client.dart';

class CompanyChatThreadScreen extends StatefulWidget {
  final String name;
  final String image;

  const CompanyChatThreadScreen({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<CompanyChatThreadScreen> createState() => _CompanyChatThreadScreen();
}

class _CompanyChatThreadScreen extends State<CompanyChatThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // تبدأ فارغة دائماً
  bool _isTyping = false;
  late final ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(ApiClient());
  }

  bool get _isChatbot => widget.name.contains('مساعد') || widget.name.contains('Assistant') || widget.name.contains('Jobito AI');

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          "isMe": true,
          "text": text,
          "time": _getCurrentTime(),
        });
        _messageController.clear();
      });

      if (_isChatbot) {
        setState(() => _isTyping = true);
        try {
          final response = await _chatService.askAiChatbot(text);
          if (mounted) {
            setState(() {
              _isTyping = false;
              _messages.add({
                "isMe": false,
                "text": response,
                "time": _getCurrentTime(),
              });
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isTyping = false;
              _messages.add({
                "isMe": false,
                "text": "عذراً، حدث خطأ في الاتصال بالمساعد الذكي.",
                "time": _getCurrentTime(),
              });
            });
          }
        }
      }
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: widget.image.startsWith('http') ? NetworkImage(widget.image) : AssetImage(widget.image) as ImageProvider),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: TextStyle(
                        color: onSurfaceColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(t.tr(en: "Online", ar: "متصل"),
                    style: const TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12), height: 1),
          Expanded(
            child: _messages.isEmpty && !_isTyping
                ? _buildEmptyChat(t, onSurfaceColor)
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: _messages.length + 1 + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader(onSurfaceColor);
                if (_isTyping && index == _messages.length + 1) {
                  return _buildTypingIndicator(onSurfaceColor);
                }
                final msg = _messages[index - 1];
                return _buildMessageBubble(context, msg, onSurfaceColor);
              },
            ),
          ),
          _buildMessageInput(context, t, isDark, onSurfaceColor),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(AppLocalizations t, Color onSurfaceColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(onSurfaceColor),
          Text(
            t.tr(en: "No messages yet. Say hi!", ar: "لا توجد رسائل بعد. قل مرحباً!"),
            style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color onSurfaceColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: widget.image.startsWith('http') ? NetworkImage(widget.image) : AssetImage(widget.image) as ImageProvider),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2, color: onSurfaceColor.withValues(alpha: 0.5)),
                ),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context).tr(en: "Typing...", ar: "يكتب..."),
                    style: TextStyle(color: onSurfaceColor, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, Map<String, dynamic> msg, Color onSurfaceColor) {
    bool isMe = msg["isMe"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(radius: 18, backgroundImage: widget.image.startsWith('http') ? NetworkImage(widget.image) : AssetImage(widget.image) as ImageProvider),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).colorScheme.primary
                        : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(msg["text"],
                      style: TextStyle(
                          color: isMe
                              ? Colors.white
                              : onSurfaceColor)),
                ),
                const SizedBox(height: 4),
                Text(msg["time"],
                    style:
                    TextStyle(color: onSurfaceColor.withValues(alpha: 0.38), fontSize: 10)),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, AppLocalizations t, bool isDark, Color onSurfaceColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _messageController,
                onChanged: (val) => setState(() {}),
                style: TextStyle(color: onSurfaceColor),
                decoration: InputDecoration(
                    hintText: t.tr(en: "Type a message", ar: "اكتب رسالة"),
                    hintStyle: TextStyle(color: onSurfaceColor.withValues(alpha: 0.38)),
                    border: InputBorder.none),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send,
                    color: _messageController.text.isEmpty
                        ? onSurfaceColor.withValues(alpha: 0.24)
                        : Theme.of(context).colorScheme.primary),
                onPressed: _messageController.text.isEmpty ? null : _sendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color onSurfaceColor) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(radius: 40, backgroundImage: widget.image.startsWith('http') ? NetworkImage(widget.image) : AssetImage(widget.image) as ImageProvider),
          const SizedBox(height: 10),
          Text(widget.name,
              style: TextStyle(
                  color: onSurfaceColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}