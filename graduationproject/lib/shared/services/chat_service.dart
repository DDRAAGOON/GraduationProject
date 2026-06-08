import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';

class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  Future<void> sendMessage(String receiverId, String content) async {
    try {
      final response = await ApiClient.post('/chat/p2p', requiresAuth: true, body: {
        'receiverId': receiverId,
        'content': content,
      });
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RecruitmentMessage>> getHistory(String receiverId) async {
    try {
      final response = await ApiClient.get('/chat/p2p/history?userId=$receiverId', requiresAuth: true);
      final data = await handleResponse(response, (map) => map);
      
      final list = data['messages'] as List? ?? [];
      
      return list.map((m) {
        final senderId = m['senderId']?.toString() ?? '';
        final isMe = senderId != receiverId;
        return RecruitmentMessage(
          id: m['_id']?.toString() ?? m['id']?.toString() ?? '',
          fromCompany: !isMe,
          text: m['content']?.toString() ?? '',
          createdAt: m['createdAt'] != null ? DateTime.tryParse(m['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
