import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../messages/new_chat_screen.dart';
import '../post/post_job.dart';
import '../setting/settings.dart';
import 'dart:io';
import '../../profile/user_data.dart';
import 'chat_tradesman.dart';


class MessagesList extends StatefulWidget {
  const MessagesList({super.key});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const NewChatScreen()));
        },
        backgroundColor: const Color(0xFFDDE6FF),
        elevation: 6,
        child: const Icon(Icons.add, color: Color(0xFF011931), size: 28),
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              backgroundImage: UserProfileData.profileImage != null
                  ? (UserProfileData.profileImage!.startsWith('http') 
                      ? NetworkImage(UserProfileData.profileImage!) 
                      : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                  : null,
              child: UserProfileData.profileImage == null 
                  ? const Icon(Icons.person, size: 20) 
                  : null,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: "Messages", ar: "الرسائل"),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          _buildIconButton(Icons.add_circle_outline, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PostJob()));
          }),
          const SizedBox(width: 8),
          _buildIconButton(Icons.settings_outlined, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
          }),
          const SizedBox(width: 24),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSearchBar(context, t),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: AnimatedBuilder(
                animation: store,
                builder: (context, _) {
                  final threads = store.tradesmanChatThreads.where((thread) => 
                    thread.name.toLowerCase().contains(_searchQuery)
                  ).toList();

                  if (threads.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            t.tr(en: "No messages yet", ar: "لا توجد رسائل بعد"),
                            style: const TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
                    itemCount: threads.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(color: Colors.grey.withOpacity(0.15), height: 1),
                    ),
                    itemBuilder: (context, index) {
                      final thread = threads[index];
                      return _buildMessageItem(
                        context,
                        name: thread.name,
                        message: thread.lastMessage,
                        time: thread.time,
                        image: thread.image,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations t) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          hintText: t.tr(en: "Search messages", ar: "البحث في الرسائل"),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
      }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatTradesman(
              name: name,
              image: image,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30, 
              backgroundColor: Colors.grey.shade200,
              backgroundImage: image.startsWith('http') 
                ? NetworkImage(image) 
                : AssetImage(image) as ImageProvider,
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
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
