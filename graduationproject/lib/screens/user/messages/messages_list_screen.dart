import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';
import 'chat_thread_screen.dart';
import 'dart:io';
import '../profile/user_data.dart';
import '../teardsman/setting/settings.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
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

  List<Map<String, String>> _filteredMessages = [];

  @override
  void initState() {
    super.initState();
    _filteredMessages = _allMessages;
    _searchController.addListener(_filterMessages);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMessages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMessages = _allMessages.where((msg) {
        return msg['name']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
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
        title: Text(
          t.messages,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF9F5F1),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // New chat logic
        },
        backgroundColor: const Color(0xFFDDE6FF),
        elevation: 6,
        child: const Icon(Icons.add, color: Color(0xFF011931), size: 28),
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
              child: _filteredMessages.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 60, color: Colors.grey.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      t.tr(en: "No messages found", ar: "لم يتم العثور على رسائل"),
                      style: const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 100), // Padding bottom for FAB
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.15),
                          height: 1,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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
        bool isOnline = false,
      }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatThreadScreen(
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
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(image),
                  backgroundColor: Colors.grey.shade200,
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
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
