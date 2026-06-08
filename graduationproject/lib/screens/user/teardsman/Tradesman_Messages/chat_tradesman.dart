import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/services/chat_service.dart';

class ChatTradesman extends StatefulWidget {
  final String userId;
  final String name;
  final String image;

  const ChatTradesman({
    super.key,
    required this.userId,
    required this.name,
    required this.image,
  });

  @override
  State<ChatTradesman> createState() => _ChatTradesmanState();
}

class _ChatTradesmanState extends State<ChatTradesman> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    if (widget.userId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final msgs = await ChatService.instance.getHistory(widget.userId);
      if (mounted) {
        setState(() {
          _messages = msgs.map((m) => {
            "isMe": !m.fromCompany,
            "text": m.text,
            "time": "${m.createdAt.hour}:${m.createdAt.minute.toString().padLeft(2, '0')}",
          }).toList().reversed.toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    final time = _getCurrentTime();
    setState(() {
      _messages.insert(0, {
        "isMe": true,
        "text": text,
        "time": time,
      });
      _messageController.clear();
    });

    if (widget.userId.isNotEmpty) {
      try {
        await ChatService.instance.sendMessage(widget.userId, text);
      } catch (e) {
        // ignore
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
    bool isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios, 
                color: Theme.of(context).colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18, 
              backgroundImage: widget.image.startsWith('http') 
                ? NetworkImage(widget.image) 
                : AssetImage(widget.image) as ImageProvider
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(t.tr(en: "Online", ar: "متصل"),
                      style: const TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.1), height: 1),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator()) 
              : _messages.isEmpty 
              ? _buildEmptyState(t)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildMessageBubble(context, msg);
                  },
                ),
          ),
          _buildMessageInput(context, t),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            t.tr(en: "No messages yet", ar: "لا توجد رسائل بعد"),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16, 
              backgroundImage: widget.image.startsWith('http') 
                ? NetworkImage(widget.image) 
                : AssetImage(widget.image) as ImageProvider
            ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)
                    ]
                  ),
                  child: Text(
                    msg["text"],
                    style: TextStyle(color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                const SizedBox(height: 4),
                Text(msg["time"],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                    hintText: t.tr(en: "Type a message", ar: "اكتب رسالة"),
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.send, color: Colors.blueAccent),
                onPressed: _sendMessage),
          ],
        ),
      ),
    );
  }
}
