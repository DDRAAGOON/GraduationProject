import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../data/models/chat/chat_room.dart';
import '../../../data/models/chat/chat_models.dart';
import '../../../shared/state/chat_store.dart';
import '../../../shared/state/company_store.dart';
import '../../../data/services/chat_service.dart';
import '../../../core/network/api_client.dart';

class CompanyChatThreadScreen extends StatefulWidget {
  final ChatRoom room;

  const CompanyChatThreadScreen({super.key, required this.room});

  @override
  State<CompanyChatThreadScreen> createState() =>
      _CompanyChatThreadScreenState();
}

class _CompanyChatThreadScreenState extends State<CompanyChatThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isUploading = false;
  File? _selectedImage;
  late final ChatService _chatService;

  String get _userId => CompanyStore.instance.companyId ?? '';
  String get _roomId => widget.room.recipientId;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(ApiClient());
    _loadMessages();
  }

  void _loadMessages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_userId.isNotEmpty) {
        ChatStore.instance.loadMessages(_userId, _roomId);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    if (_userId.isEmpty) return;

    final imageToSend = _selectedImage;
    setState(() {
      _selectedImage = null;
      if (imageToSend != null) _isUploading = true;
    });

    _messageController.clear();

    try {
      String type = 'text';
      String content = text;

      if (imageToSend != null) {
        // Upload image first
        final url = await _chatService.uploadFile(imageToSend);
        type = 'image';
        content = url;
      }

      final request = ChatP2PRequest(
        senderId: _userId,
        recipientId: _roomId,
        content: content,
        type: type,
      );

      final newMsg = await _chatService.sendP2PMessage(request);
      ChatStore.instance.addMessage(_roomId, newMsg);

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to send message')));
      }
    } finally {
      if (mounted && imageToSend != null) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF001E3A)
        : const Color(0xFFF8FBF4);
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
            CircleAvatar(
              radius: 18,
              backgroundColor: cs.primaryContainer,
              backgroundImage: widget.room.avatarUrl != null
                  ? NetworkImage(widget.room.avatarUrl!)
                  : null,
              child: widget.room.avatarUrl == null
                  ? Text(
                      widget.room.name.isNotEmpty
                          ? widget.room.name[0].toUpperCase()
                          : '?',
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.room.name,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(color: onSurfaceColor.withOpacity(0.12), height: 1),
          Expanded(
            child: AnimatedBuilder(
              animation: ChatStore.instance,
              builder: (context, _) {
                final isLoading = ChatStore.instance.isLoadingMessages(_roomId);
                final messages = ChatStore.instance.getMessages(_roomId);

                if (isLoading && messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (messages.isEmpty) {
                  return _buildEmptyChat(t, onSurfaceColor);
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Show newest at bottom
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(context, msg, onSurfaceColor);
                  },
                );
              },
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
                      height: 80,
                      width: 80,
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
                  if (_isUploading)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
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
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: widget.room.avatarUrl != null
                ? NetworkImage(widget.room.avatarUrl!)
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            widget.room.name,
            style: TextStyle(
              color: onSurfaceColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t.tr(
              en: "No messages yet. Say hi!",
              ar: "لا توجد رسائل بعد. قل مرحباً!",
            ),
            style: TextStyle(color: onSurfaceColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    ChatMessage msg,
    Color onSurfaceColor,
  ) {
    bool isMe = msg.senderId == _userId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 14,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: widget.room.avatarUrl != null
                  ? NetworkImage(widget.room.avatarUrl!)
                  : null,
            ),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).colorScheme.primary
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 20),
                    ),
                  ),
                  child: msg.type == 'image'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            msg.content,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) =>
                                const Icon(Icons.broken_image),
                          ),
                        )
                      : Text(
                          msg.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : onSurfaceColor,
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(
                    color: onSurfaceColor.withOpacity(0.38),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageInput(
    BuildContext context,
    AppLocalizations t,
    bool isDark,
    Color onSurfaceColor,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.image_outlined,
                color: onSurfaceColor.withOpacity(0.5),
              ),
              onPressed: _pickImage,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                onChanged: (val) => setState(() {}),
                style: TextStyle(color: onSurfaceColor),
                decoration: InputDecoration(
                  hintText: t.tr(en: "Type a message", ar: "اكتب رسالة"),
                  hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.38)),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: _messageController.text.isEmpty && _selectedImage == null
                    ? onSurfaceColor.withOpacity(0.24)
                    : cs.primary,
              ),
              onPressed:
                  _messageController.text.isEmpty && _selectedImage == null
                  ? null
                  : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
