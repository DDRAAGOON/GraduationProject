import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';
import 'chat_thread_screen.dart';
import 'new_chat_screen.dart';

import '../../../shared/services/chat_service.dart';
import '../../../data/api/api_client.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    try {
      final chats = await ChatService.instance.getMyChats();
      if (!mounted) return;
      setState(() {
        _chats = chats;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredChats {
    if (_searchQuery.isEmpty) return _chats;
    return _chats.where((chat) {
      final participant = _participantOf(chat);
      final name = _participantName(participant).toLowerCase();
      final lastMessage = _lastMessageOf(chat);
      final message =
          (lastMessage['content'] ?? lastMessage['text'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery) || message.contains(_searchQuery);
    }).toList();
  }

  Map<String, dynamic> _participantOf(Map<String, dynamic> chat) {
    if (chat['participant'] is Map) {
      return Map<String, dynamic>.from(chat['participant'] as Map);
    }
    final participants = chat['participants'];
    if (participants is List && participants.isNotEmpty && participants.first is Map) {
      return Map<String, dynamic>.from(participants.first as Map);
    }
    return {};
  }

  String _participantName(Map<String, dynamic> participant) {
    return participant['fullName']?.toString() ??
        participant['name']?.toString() ??
        'User';
  }

  Map<String, dynamic> _lastMessageOf(Map<String, dynamic> chat) {
    if (chat['lastMessage'] is Map) {
      return Map<String, dynamic>.from(chat['lastMessage'] as Map);
    }
    return {};
  }

  String _formatTime(Map<String, dynamic> lastMessage) {
    final createdAt = lastMessage['createdAt']?.toString();
    if (createdAt == null || createdAt.isEmpty) return '';
    final date = DateTime.tryParse(createdAt)?.toLocal();
    if (date == null) return '';
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF001E3A)
        : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;
    final filteredChats = _filteredChats;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewChatScreen()),
        ),
        backgroundColor: const Color(0xFFDDE6FF),
        elevation: 4,
        child: const Icon(Icons.add, color: Color(0xFF011931)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadChats,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  t.messages,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildSearchBar(context, t, isDark, onSurfaceColor),
                const SizedBox(height: 20),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredChats.isEmpty
                      ? _buildEmptyState(t, onSurfaceColor)
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredChats.length,
                          separatorBuilder: (context, index) => Divider(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.12),
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final chat = filteredChats[index];
                            final participant = _participantOf(chat);
                            final lastMessage = _lastMessageOf(chat);
                            final name = _participantName(participant);
                            final message =
                                lastMessage['content']?.toString() ??
                                lastMessage['text']?.toString() ??
                                '';
                            final image =
                                ApiClient.resolveImageUrl(
                                  participant['avatar']?.toString() ??
                                      participant['photoUrl']?.toString(),
                                ) ??
                                '';
                            final receiverId =
                                participant['_id']?.toString() ??
                                participant['id']?.toString() ??
                                '';
                            final roomId =
                                chat['_id']?.toString() ??
                                chat['id']?.toString() ??
                                chat['roomId']?.toString() ??
                                '';

                            return _buildMessageItem(
                              context,
                              name: name,
                              message: message,
                              time: _formatTime(lastMessage),
                              image: image,
                              receiverId: receiverId,
                              roomId: roomId,
                              onSurfaceColor: onSurfaceColor,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations t, Color onSurfaceColor) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: onSurfaceColor.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 16),
              Text(
                t.tr(en: "No messages yet", ar: "لا توجد رسائل بعد"),
                style: TextStyle(
                  color: onSurfaceColor.withValues(alpha: 0.54),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    AppLocalizations t,
    bool isDark,
    Color onSurfaceColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: onSurfaceColor),
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: onSurfaceColor.withValues(alpha: 0.54),
          ),
          hintText: t.tr(en: "Search messages", ar: "البحث في الرسائل"),
          hintStyle: TextStyle(color: onSurfaceColor.withValues(alpha: 0.38)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required String image,
    required String receiverId,
    required String roomId,
    required Color onSurfaceColor,
  }) {
    return InkWell(
      onTap: receiverId.isEmpty && roomId.isEmpty
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatThreadScreen(
                  name: name,
                  image: image,
                  receiverId: receiverId.isNotEmpty ? receiverId : null,
                  roomId: receiverId.isEmpty && roomId.isNotEmpty ? roomId : null,
                ),
              ),
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: image.startsWith('http')
                  ? NetworkImage(image)
                  : AssetImage(
                          image.isEmpty ? AppImages.companyProfile2 : image,
                        )
                        as ImageProvider,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: onSurfaceColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: onSurfaceColor.withValues(alpha: 0.38),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: onSurfaceColor.withValues(alpha: 0.54),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
