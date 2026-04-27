import 'package:flutter/material.dart';
import '../../../../constants/app_images.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../post/post_Job.dart';
import '../setting/settings.dart';
import 'chat_tradesman.dart';


class MessagesList extends StatefulWidget {
  const MessagesList({super.key});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allMessages = [
    {
      "name": "Joe Bartmann",
      "message": "Hey thanks for your interview...",
      "time": "3:40 PM",
      "image": AppImages.companyProfile2,
    },
    {
      "name": "Ally Wales",
      "message": "Hey thanks for your interview...",
      "time": "3:40 PM",
      "image": AppImages.companyProfile3,
    },
    {
      "name": "James Gardner",
      "message": "Hey thanks for your interview...",
      "time": "3:40 PM",
      "image": AppImages.companyProfile4,
    },
    {
      "name": "Allison Geidt",
      "message": "Hey thanks for your interview...",
      "time": "3:40 PM",
      "image": AppImages.companyProfile5,
    },
    {
      "name": "Ruben Culhane",
      "message": "Hey thanks for your interview...",
      "time": "3:40 PM",
      "image": AppImages.companyProfile6,
    },
    {
      "name": "Lydia Diaz",
      "message": "Hey thanks for your interview...",
      "time": "3:40 PM",
      "image": AppImages.companyProfile7,
    },
  ];

  late List<Map<String, String>> _filteredMessages;

  @override
  void initState() {
    super.initState();
    _filteredMessages = _allMessages;
    _searchController.addListener(_filterMessages);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMessages);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMessages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMessages = _allMessages
          .where((msg) => msg['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for NewChatScreen
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.tr(en: "New chat coming soon", ar: "دردشة جديدة قريباً")))
          );
        },
        backgroundColor: const Color(0xFFDDE6FF),
        elevation: 4,
        child: const Icon(Icons.add, color: Color(0xFF011931)),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/company/logo/logo.png',
          height: 35,
          fit: BoxFit.contain,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Text(
                t.tr(en: "Messages", ar: "الرسائل"),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Search Bar
              _buildSearchBar(t),
              const SizedBox(height: 20),
              // Messages List
              Expanded(
                child: _filteredMessages.isEmpty
                    ? Center(child: Text(t.tr(en: "No messages found", ar: "لم يتم العثور على رسائل"), style: const TextStyle(color: Colors.black54)))
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredMessages.length,
                  itemBuilder: (context, index) {
                    final msg = _filteredMessages[index];
                    return Column(
                      children: [
                        _buildMessageItem(
                          context,
                          name: msg['name']!,
                          message: msg['message']!,
                          time: msg['time']!,
                          image: msg['image']!,
                        ),
                        Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
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
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 20),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
          hintText: t.tr(en: "Search messages", ar: "البحث في الرسائل"),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
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
        bool isOnline = false,
        bool isHighlighted = false,
      }) {
    return GestureDetector(
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlighted ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
          borderRadius: isHighlighted
              ? const BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(20),
          )
              : BorderRadius.zero,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(image),
              backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isOnline) ...[
                        const SizedBox(width: 5),
                        const Icon(Icons.circle, color: Colors.blue, size: 8),
                      ],
                      const Spacer(),
                      Text(
                        time,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
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
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
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