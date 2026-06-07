import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../chat/chat_models.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  Future<List<ChatRoom>> getChatRooms() async {
    final response = await _apiClient.get(ApiConstants.chatRooms);
    final List<dynamic> data = response.data;
    return data.map((json) => ChatRoom.fromJson(json)).toList();
  }

  Future<List<ChatMessage>> getMessages(String roomId) async {
    final response = await _apiClient.get(ApiConstants.chatMessages(roomId));
    final List<dynamic> data = response.data;
    return data.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<ChatMessage> sendMessage(String roomId, String text) async {
    final response = await _apiClient.post(
      ApiConstants.chatMessages(roomId),
      data: {'text': text},
    );
    return ChatMessage.fromJson(response.data);
  }

  Future<String> askAi(String prompt) async {
    final response = await _apiClient.post(
      ApiConstants.aiChat,
      data: {'prompt': prompt},
    );
    return response.data['reply'];
  }

  Future<List<dynamic>> getAiHistory(String userId) async {
    final response = await _apiClient.get(ApiConstants.aiHistory(userId));
    return response.data;
  }
}
