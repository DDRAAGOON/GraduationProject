// Inbox of recruiter message threads.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';
import '../../../shared/state/chat_store.dart';
import '../../../shared/state/company_store.dart';
import '../../../data/models/chat/chat_room.dart';
import '../../../core/network/api_client.dart';
import '../../../data/services/chat_service.dart';

class CompanyMessagesListScreen extends StatefulWidget {
  const CompanyMessagesListScreen({super.key});

  @override
  State<CompanyMessagesListScreen> createState() =>
      _CompanyMessagesListScreenState();
}

class _CompanyMessagesListScreenState extends State<CompanyMessagesListScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure chat service is initialized in store
    ChatStore.instance.initialize(ChatService(ApiClient()));

    // Load chats using company ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = CompanyStore.instance.companyId;
      if (userId != null) {
        ChatStore.instance.loadChatRooms(userId);
      }
    });
  }

  Future<void> _refresh() async {
    final userId = CompanyStore.instance.companyId;
    if (userId != null) {
      await ChatStore.instance.loadChatRooms(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: t.tr(en: 'Messages', ar: 'الرسائل'),
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      body: AnimatedBuilder(
        animation: ChatStore.instance,
        builder: (context, _) {
          final isLoading = ChatStore.instance.isLoadingRooms;
          final rooms = ChatStore.instance.chatRooms;

          if (isLoading && rooms.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (rooms.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: cs.outlineVariant,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      t.tr(en: 'No messages yet', ar: 'لا توجد رسائل بعد'),
                      style: TextStyle(color: cs.onSurface.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) => _ChatRoomTile(room: rooms[i]),
              separatorBuilder: (_, i) =>
                  Divider(color: cs.outlineVariant.withOpacity(0.5), height: 1),
              itemCount: rooms.length,
            ),
          );
        },
      ),
      bottomNavigationBar: const CompanyBottomNav(current: CompanyTab.chat),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRoutes.companyNewChat),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  const _ChatRoomTile({required this.room});

  final ChatRoom room;

  String _formatTime(DateTime date, bool isAr) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    if (diff.inDays < 7) {
      return isAr ? 'منذ ${diff.inDays} يوم' : '${diff.inDays}d ago';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: cs.primaryContainer,
        backgroundImage: room.avatarUrl != null
            ? NetworkImage(room.avatarUrl!)
            : null,
        child: room.avatarUrl == null
            ? Text(
                room.name.isNotEmpty ? room.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        room.name,
        style: TextStyle(
          fontWeight: room.unreadCount > 0
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        room.lastMessage.isEmpty
            ? t.tr(en: 'Image / File', ar: 'صورة / ملف')
            : room.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: room.unreadCount > 0
              ? FontWeight.bold
              : FontWeight.normal,
          color: room.unreadCount > 0
              ? cs.onSurface
              : cs.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(room.lastMessageTime, t.isAr),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: room.unreadCount > 0
                  ? cs.primary
                  : cs.onSurface.withOpacity(0.5),
              fontWeight: room.unreadCount > 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          if (room.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                room.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        ChatStore.instance.markRoomAsRead(room.recipientId);
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.companyChatThread, arguments: room);
      },
    );
  }
}
