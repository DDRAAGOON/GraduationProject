import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/api/api_client.dart';

class AiChatbotService {
  AiChatbotService._();
  static final AiChatbotService instance = AiChatbotService._();

  static const _storage = FlutterSecureStorage();

  Future<void> sendChatbotMessage({
    required String message,
    required String userId,
    required Function(String chunk) onChunk,
    required Function() onDone,
  }) async {
    final token = await _storage.read(key: 'jwt_token');
    
    final request = http.Request(
      'POST',
      Uri.parse('${ApiClient.baseUrl}/ai-chatbot/chat'),
    );
    request.headers['Content-Type'] = 'application/json';
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.body = jsonEncode({'message': message, 'userId': userId});

    try {
      final streamedResponse = await http.Client().send(request);
      
      streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data != '[DONE]') {
                onChunk(data);
              }
            }
          },
          onDone: onDone,
          onError: (e) {
            onDone();
          },
          cancelOnError: true,
        );
    } catch (e) {
      onDone();
    }
  }

  Future<List<dynamic>> getChatbotHistory(String userId) async {
    try {
      final response = await ApiClient.get('/ai-chatbot/history/$userId', requiresAuth: true);
      final data = await handleResponse(response, (map) => map);
      return data['history'] ?? data['data'] ?? data ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
