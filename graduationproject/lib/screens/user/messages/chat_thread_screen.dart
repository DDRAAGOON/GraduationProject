import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/chat_service.dart';
import '../../../shared/services/ai_chatbot_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';

class ChatThreadScreen extends StatefulWidget {
  final String name;
  final String image;
  final String? receiverId; // For P2P
  final String? roomId;     // For Rooms

  const ChatThreadScreen({
    super.key,
    required this.name,
    required this.image,
    this.receiverId,
    this.roomId,
  });

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; 
  bool _isThinking = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      if (widget.roomId != null) {
        final history = await ChatService.instance.getRoomMessages(widget.roomId!);
        setState(() {
          _messages.clear();
          for (var msg in history) {
            _messages.add({
              "isMe": !msg.fromCompany,
              "text": msg.text,
              "time": "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
            });
          }
        });
      } else if (widget.receiverId != null) {
        final history = await ChatService.instance.getHistory(widget.receiverId!);
        setState(() {
          _messages.clear();
          for (var msg in history) {
            _messages.add({
              "isMe": !msg.fromCompany,
              "text": msg.text,
              "time": "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
            });
          }
        });
      } else {
        final userId = RecruitmentSyncStore.instance.currentUserId;
        if (userId.isEmpty) return;
        
        final history = await AiChatbotService.instance.getChatbotHistory(userId);
        setState(() {
          _messages.clear();
          for (var msg in history) {
            final text = msg['message'] ?? msg['text'] ?? '';
            final role = msg['role']?.toString().toLowerCase() ?? '';
            final isUser = role == 'user' || msg['fromCompany'] == false;
            
            _messages.add({
              "isMe": isUser,
              "text": text,
              "time": "", 
            });
          }
        });
      }
      _scrollToBottom();
    } catch (e) {
      // Handle error
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
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        "isMe": true,
        "text": text,
        "time": _getCurrentTime(),
      });
      _messageController.clear();
    });
    _scrollToBottom();

    if (widget.roomId != null) {
      try {
        await ChatService.instance.sendRoomMessage(widget.roomId!, text);
      } catch (e) {}
    } else if (widget.receiverId != null) {
      try {
        await ChatService.instance.sendMessage(widget.receiverId!, text);
      } catch (e) {}
    } else {
      final userId = RecruitmentSyncStore.instance.currentUserId;
      setState(() => _isThinking = true);
      
      // Add empty assistant message for streaming
      int assistantMsgIndex = -1;
      
      await AiChatbotService.instance.sendChatbotMessage(
        message: text,
        userId: userId,
        onChunk: (chunk) {
          setState(() {
            if (assistantMsgIndex == -1) {
              _messages.add({
                "isMe": false,
                "text": chunk,
                "time": _getCurrentTime(),
              });
              assistantMsgIndex = _messages.length - 1;
            } else {
              _messages[assistantMsgIndex]["text"] += chunk;
            }
          });
          _scrollToBottom();
        },
        onDone: () {
          setState(() => _isThinking = false);
        },
      );
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
            child: _messages.isEmpty && !_isThinking
              ? _buildEmptyChat(t, onSurfaceColor)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: _messages.length + 1 + (_isThinking ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildHeader(onSurfaceColor);
                    
                    if (_isThinking && index == _messages.length + 1) {
                      return _buildThinkingIndicator(onSurfaceColor);
                    }
                    
                    if (index > _messages.length) return const SizedBox.shrink();

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

  Widget _buildThinkingIndicator(Color onSurfaceColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18, 
            backgroundImage: widget.image.startsWith('http') 
              ? NetworkImage(widget.image) 
              : AssetImage(widget.image) as ImageProvider
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: (Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(onSurfaceColor.withValues(alpha: 0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(AppLocalizations t, Color onSurfaceColor) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(onSurfaceColor),
          Text(
            isAr ? "اسأل عن أي شيء يخص مسارك المهني، سيرتك الذاتية، أو المقابلات" : "Ask anything about your career, CV, or interviews",
            textAlign: TextAlign.center,
            style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.5), fontSize: 13),
          ),
          const SizedBox(height: 30),
          _buildSuggestionCategory(
            icon: Icons.description_outlined,
            title: isAr ? "نصائح مهنية" : "Career Advice",
            suggestions: [
              isAr ? "كيف أحسن سيرتي الذاتية؟" : "How to improve my CV?",
              isAr ? "نصائح لمقابلة عمل ناجحة" : "Tips for a successful interview",
            ],
            onSurfaceColor: onSurfaceColor,
          ),
          _buildSuggestionCategory(
            icon: Icons.edit_note,
            title: isAr ? "كتابة مهنية" : "Professional Writing",
            suggestions: [
              isAr ? "اكتب خطاب تغطية (Cover Letter) احترافي" : "Write a professional Cover Letter",
              isAr ? "عدل نبذتي الشخصية لـ LinkedIn" : "Edit my LinkedIn bio",
            ],
            onSurfaceColor: onSurfaceColor,
          ),
          _buildSuggestionCategory(
            icon: Icons.work_outline,
            title: isAr ? "البحث عن عمل والرواتب" : "Job Search & Salaries",
            suggestions: [
              isAr ? "أكثر المهارات المطلوبة في 2024" : "Most in-demand skills in 2024",
              isAr ? "كيف أتفاوض على راتبي بشكل صحيح؟" : "How to negotiate my salary?",
            ],
            onSurfaceColor: onSurfaceColor,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSuggestionCategory({
    required IconData icon,
    required String title,
    required List<String> suggestions,
    required Color onSurfaceColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: onSurfaceColor.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: suggestions.map((text) => _buildSuggestionChip(text, onSurfaceColor)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text, Color onSurfaceColor) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: onSurfaceColor.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
        ),
        child: Text(
          text,
          style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.8), fontSize: 12),
        ),
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
