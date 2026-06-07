import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/chat/chat_models.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  Future<ChatMessage> sendP2PMessage(ChatP2PRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.chatP2P,
      data: request.toJson(),
    );
    return ChatMessage.fromJson(response.data);
  }

  Future<List<ChatMessage>> getP2PHistory(String userId, String otherId, {int page = 1}) async {
    final response = await _apiClient.get(
      ApiConstants.chatHistory,
      queryParameters: {'userId': userId, 'otherId': otherId, 'page': page},
    );
    final List<dynamic> data = response.data;
    return data.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<List<dynamic>> getMyChats(String userId) async {
    final response = await _apiClient.get(ApiConstants.myChats(userId));
    return response.data;
  }

  Future<void> markAsRead(String userId, String otherId) async {
    await _apiClient.put(
      ApiConstants.chatRead,
      data: {'userId': userId, 'otherId': otherId},
    );
  }

  Future<String> uploadFile(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _apiClient.post(
      ApiConstants.chatUpload,
      data: formData,
    );
    return response.data['url'] ?? '';
  }

  Future<UserInfo> getUserInfo(String userId) async {
    final response = await _apiClient.get(ApiConstants.chatUserInfo(userId));
    return UserInfo.fromJson(response.data);
  }

  // AI Chatbot
  Future<String> askAiChatbot(String message, {String? userId, File? image}) async {
    final formData = FormData.fromMap({
      'message': message,
      if (userId != null) 'userId': userId,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });

    final response = await _apiClient.post(
      ApiConstants.aiChatbot,
      data: formData,
    );
    return response.data['reply'] ?? '';
  }

  // Old structure support
  Future<List<dynamic>> getChatRooms() async {
    final response = await _apiClient.get(ApiConstants.chatRooms);
    return response.data;
  }
}
