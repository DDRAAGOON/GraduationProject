import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.tr(en: "New Chat", ar: "محادثة جديدة"),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF49769F), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF49769F).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _isSearching = value.length >= 2;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: t.tr(
                          en: "Search users by name or email...",
                          ar: "ابحث عن مستخدم بالاسم أو الإيميل...",
                        ),
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (!_isSearching)
              Center(
                child: Text(
                  t.tr(
                    en: "Type at least 2 characters to search",
                    ar: "اكتب حرفين على الأقل للبحث",
                  ),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    "Search results will appear here",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
