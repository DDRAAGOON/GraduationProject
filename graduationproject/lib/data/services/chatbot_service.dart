import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/chat/chatbot_message.dart';

class ChatbotService {
  final ApiClient _apiClient;

  ChatbotService(this._apiClient);

  Future<String> askAiChatbot(
    String message, {
    String? userId,
    File? image,
  }) async {
    try {
      dynamic requestData;
      if (image != null) {
        requestData = FormData.fromMap({
          'message': message,
          if (userId != null) 'userId': userId,
          'image': await MultipartFile.fromFile(image.path),
        });
      } else {
        requestData = {
          'message': message,
          if (userId != null) 'userId': userId,
        };
      }

      final response = await _apiClient.post(
        ApiConstants.aiChatbot,
        data: requestData,
      );
      return response.data['response']?.toString() ??
          response.data['reply']?.toString() ??
          '';
    } catch (e) {
      if (kDebugMode) debugPrint('❌ AI Chatbot error: $e');
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<ChatbotMessage>> getAiChatbotHistory(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.aiChatbotHistory(userId),
      );
      final List<dynamic> data = response.data['data'] ?? response.data ?? [];
      return data.map((json) => ChatbotMessage.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching AI history: $e');
      return [];
    }
  }
}
