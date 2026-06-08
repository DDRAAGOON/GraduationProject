import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';

class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  Future<void> sendMessage(
    String recipientId,
    String content, {
    String type = 'text',
  }) async {
    try {
      final senderId = await ApiClient.getUserId() ?? '';
      final response = await ApiClient.post(
        '/chat/p2p',
        body: {
          'senderId': senderId,
          'recipientId': recipientId,
          'content': content,
          'type': type,
        },
      );
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMyChats() async {
    try {
      final userId = await ApiClient.getUserId() ?? '';
      if (userId.isEmpty) return [];
      final response = await ApiClient.get('/chat/my-chats/$userId', requiresAuth: true);
      final data = await handleResponse(response, (map) => map);
      final list = data['data'] ?? data['chats'] ?? data ?? [];
      return (list as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return []; // Return empty if endpoint fails or doesn't exist yet
    }
  }

  Future<List<RecruitmentMessage>> getHistory(String otherId) async {
    try {
      final userId = await ApiClient.getUserId() ?? '';
      final response = await ApiClient.get(
        '/chat/p2p/history?userId=$userId&otherId=$otherId',
        requiresAuth: true,
      );
      final data = await handleResponse(response, (map) => map);

      final list = data['messages'] as List? ?? [];

      return list.map((m) {
        final senderId = m['senderId']?.toString() ?? '';
        final isMe = senderId != otherId;
        return RecruitmentMessage(
          id: m['_id']?.toString() ?? m['id']?.toString() ?? '',
          fromCompany: !isMe,
          text: m['content']?.toString() ?? '',
          createdAt: m['createdAt'] != null
              ? DateTime.tryParse(m['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now(),
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadChatFile(String filePath) async {
    try {
      final response = await ApiClient.multipartRequest(
        '/chat/upload',
        method: 'POST',
        files: {'file': filePath},
        requiresAuth: true,
      );
      final data = await handleResponse(response, (map) => map);
      return data['url']?.toString();
    } catch (e) {
      return null;
    }
  }

  // --- Room-based Chat APIs ---

  Future<List<Map<String, dynamic>>> getChatRooms() async {
    try {
      final response = await ApiClient.get('/chat/rooms', requiresAuth: true);
      final data = await handleResponse(response, (map) => map);
      final list = data['rooms'] ?? data['data'] ?? data ?? [];
      return (list as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<List<RecruitmentMessage>> getRoomMessages(String roomId) async {
    try {
      final response = await ApiClient.get('/chat/rooms/$roomId/messages', requiresAuth: true);
      final data = await handleResponse(response, (map) => map);
      final list = data['messages'] ?? data['data'] ?? [];
      
      final myId = await ApiClient.getUserId() ?? '';

      return (list as List).map((m) {
        final senderId = m['senderId']?.toString() ?? '';
        return RecruitmentMessage(
          id: m['_id']?.toString() ?? m['id']?.toString() ?? '',
          fromCompany: senderId != myId,
          text: m['text']?.toString() ?? m['content']?.toString() ?? '',
          createdAt: DateTime.tryParse(m['createdAt']?.toString() ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> sendRoomMessage(String roomId, String text) async {
    try {
      final response = await ApiClient.post(
        '/chat/rooms/$roomId/messages',
        body: {'text': text},
      );
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
