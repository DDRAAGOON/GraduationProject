import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/models/message_thread.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../data/services/chat_service.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/chat/chat_models.dart';

class CompanyNewChatScreen extends StatefulWidget {
  const CompanyNewChatScreen({super.key});

  @override
  State<CompanyNewChatScreen> createState() => _CompanyNewChatScreenState();
}

class _CompanyNewChatScreenState extends State<CompanyNewChatScreen> {
  final _searchController = TextEditingController();
  final ChatService _chatService = ChatService(ApiClient());

  List<UserInfo> _searchResults = [];
  bool _isSearching = false;
  String _lastQuery = '';

  // ✅ Debounce Timer لتجنب البحث المتكرر
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel(); // ✅ إلغاء Timer عند الخروج
    _searchController.dispose();
    super.dispose();
  }

  /// 🔍 البحث عن مستخدمين من الـ Backend (مع Debounce)
  Future<void> _searchUsers(String query) async {
    // ✅ إلغاء البحث السابق
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _lastQuery = '';
      });
      return;
    }

    // ✅ Debounce: تأخير 500ms قبل البحث
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // تجنب البحث المكرر
      if (query == _lastQuery) return;
      _lastQuery = query;

      if (!mounted) return;
      setState(() => _isSearching = true);

      try {
        if (kDebugMode) {
          debugPrint('🔍 Searching for: $query');
        }

        final results = await _chatService.searchUsers(query);

        if (!mounted) return;
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });

        if (kDebugMode) {
          debugPrint('✅ Found ${results.length} users');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Search error: $e');
        }

        if (!mounted) return;
        setState(() => _isSearching = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في البحث: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return AppScaffold(
      title: t.newChat,
      body: Column(
        children: [
          // ✅ حقل البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchUsers,
              decoration: InputDecoration(
                hintText: t.searchUsersHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchUsers('');
                  },
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // ✅ عرض النتائج
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchController.text.isEmpty
                        ? 'ابحث عن مستخدمين بالاسم أو الإيميل'
                        : 'لا توجد نتائج',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];

                // ✅ التحقق من صحة الـ photoUrl
                final bool hasValidPhoto = user.photoUrl != null &&
                    user.photoUrl!.isNotEmpty &&
                    (user.photoUrl!.startsWith('http://') ||
                        user.photoUrl!.startsWith('https://'));

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: hasValidPhoto
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: !hasValidPhoto
                          ? Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      )
                          : null,
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: user.role != null
                        ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.role!,
                        style: const TextStyle(fontSize: 10, color: Colors.blue),
                      ),
                    )
                        : null,
                    onTap: () {
                      final thread = MessageThread(
                        id: 'thread_${user.id}',
                        title: user.name,
                        subtitle: t.startNewConversation,
                        lastTimeLabelEn: 'Now',
                        lastTimeLabelAr: 'الآن',
                      );
                      Navigator.of(context).pushReplacementNamed(
                        AppRoutes.companyChatThread,
                        arguments: thread,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}