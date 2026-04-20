import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ChatThreadScreen extends StatefulWidget {
  final String name;
  final String image;

  const ChatThreadScreen({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "isMe": true,
          "text": _messageController.text.trim(),
          "time": _getCurrentTime(),
        });
        _messageController.clear();
      });
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: AssetImage(widget.image)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const Text("Online",
                    style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader();
                final msg = _messages[index - 1];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          _buildMessageInput(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(radius: 18, backgroundImage: AssetImage(widget.image)),
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
                    color: isMe ? const Color(0xFF49769F) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(msg["text"],
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87)),
                ),
                const SizedBox(height: 4),
                Text(msg["time"],
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 10)),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.white54),
                onPressed: () {}),
            Expanded(
              child: TextField(
                controller: _messageController,
                onChanged: (val) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send,
                    color: _messageController.text.isEmpty
                        ? Colors.white24
                        : const Color(0xFF49769F)),
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
          CircleAvatar(radius: 40, backgroundImage: AssetImage(widget.image)),
          const SizedBox(height: 10),
          Text(widget.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

