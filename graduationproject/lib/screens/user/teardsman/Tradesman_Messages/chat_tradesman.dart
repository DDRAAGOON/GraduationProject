import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/recruitment_sync_store.dart';

class ChatTradesman extends StatefulWidget {
  final String name;
  final String image;

  const ChatTradesman({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<ChatTradesman> createState() => _ChatTradesmanState();
}

class _ChatTradesmanState extends State<ChatTradesman> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
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
      
      // Update global store so it appears in Messages List
      RecruitmentSyncStore.instance.updateTradesmanChat(
        widget.name, 
        widget.image, 
        text
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18, 
              backgroundColor: Colors.grey.shade200,
              backgroundImage: widget.image.startsWith('http') 
                ? NetworkImage(widget.image) 
                : AssetImage(widget.image) as ImageProvider
            ),
            const SizedBox(width: 10),
            Column(
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
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(color: Theme.of(context).dividerColor.withOpacity(0.12), height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader();
                final msg = _messages[index - 1];
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

  Widget _buildMessageBubble(BuildContext context, Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 18, 
              backgroundColor: Colors.grey.shade200,
              backgroundImage: widget.image.startsWith('http') 
                ? NetworkImage(widget.image) 
                : AssetImage(widget.image) as ImageProvider
            ),
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
                        : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(msg["text"],
                      style: TextStyle(
                          color: isMe
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface)),
                ),
                const SizedBox(height: 4),
                Text(msg["time"],
                    style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), fontSize: 10)),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.attach_file, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                onPressed: () {}),
            Expanded(
              child: TextField(
                controller: _messageController,
                onChanged: (val) => setState(() {}),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                    hintText: t.tr(en: "Type a message", ar: "اكتب رسالة"),
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
                    border: InputBorder.none),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send,
                    color: _messageController.text.isEmpty
                        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.24)
                        : Theme.of(context).colorScheme.primary),
                onPressed: _messageController.text.isEmpty ? null : _sendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40, 
            backgroundColor: Colors.grey.shade200,
            backgroundImage: widget.image.startsWith('http') 
                ? NetworkImage(widget.image) 
                : AssetImage(widget.image) as ImageProvider
          ),
          const SizedBox(height: 10),
          Text(widget.name,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
