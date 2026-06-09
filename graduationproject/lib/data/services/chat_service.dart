import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/chat/chat_models.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  // ═══════════════════════════════════════════════════════════════
  // P2P Messaging
  // ═══════════════════════════════════════════════════════════════

  Future<ChatMessage> sendP2PMessage(ChatP2PRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.chatP2P,
        data: request.toJson(),
      );
      return ChatMessage.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<ChatMessage>> getP2PHistory(
      String userId,
      String otherId, {
        int page = 1,
      }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.chatHistory,
        queryParameters: {'userId': userId, 'otherId': otherId, 'page': page},
      );
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<dynamic>> getMyChats(String userId) async {
    try {
      final response = await _apiClient.get(ApiConstants.myChats(userId));
      final data = response.data;

      // ✅ التحقق من نوع البيانات قبل المعالجة
      if (data is Map && data['data'] is List) {
        return data['data'] as List;
      } else if (data is List) {
        return data;
      }

      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Error fetching chats: $e');
      return [];
    }
  }

  Future<void> markAsRead(String userId, String otherId) async {
    try {
      await _apiClient.put(
        ApiConstants.chatRead,
        data: {'userId': userId, 'otherId': otherId},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // File Upload
  // ═══════════════════════════════════════════════════════════════

  Future<String> uploadFile(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });
      final response = await _apiClient.post(
        ApiConstants.chatUpload,
        data: formData,
      );
      return response.data['url'] ?? '';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // User Info & Search ( الدالة الجديدة مضافة هنا)
  // ═══════════════════════════════════════════════════════════════

  Future<UserInfo> getUserInfo(String userId) async {
    try {
      final response = await _apiClient.get(ApiConstants.chatUserInfo(userId));
      final data = response.data['data'] ?? response.data;
      return UserInfo.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 🔍 البحث عن مستخدمين بالاسم أو الإيميل
  Future<List<UserInfo>> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      if (kDebugMode) {
        debugPrint('🔍 ===== SEARCH START =====');
        debugPrint('🔍 Query: "$query"');
      }

      // ✅ نجيب كل المستخدمين من السيرفر
      final response = await _apiClient.get('/users');

      // ✅ معالجة صحيحة للـ response
      List<dynamic> rawData = [];

      if (response.data is List) {
        rawData = response.data as List;
        if (kDebugMode) {
          debugPrint('📦 Received ${rawData.length} users (List format)');
        }
      } else if (response.data is Map) {
        rawData = response.data['data'] ??
            response.data['users'] ??
            [];
        if (kDebugMode) {
          debugPrint('📦 Received ${rawData.length} users (Map format)');
        }
      }

      // ✅ طباعة البيانات الخام للتشخيص
      if (kDebugMode && rawData.isNotEmpty) {
        debugPrint('📋 First user raw data:');
        debugPrint('   - Keys: ${rawData.first.keys.toList()}');
        debugPrint('   - ID: ${rawData.first['userId'] ?? rawData.first['id']}');
        debugPrint('   - Name: ${rawData.first['fullName'] ?? rawData.first['name']}');
        debugPrint('   - Email: ${rawData.first['email']}');
      }

      // ✅ الفلترة محلياً
      final queryLower = query.toLowerCase();
      final filtered = rawData.where((json) {
        if (json is! Map) {
          if (kDebugMode) debugPrint('⚠️ Skipping non-Map item: ${json.runtimeType}');
          return false;
        }

        final name = (json['fullName'] ?? json['name'] ?? json['username'] ?? '').toString().toLowerCase();
        final email = (json['email'] ?? '').toString().toLowerCase();

        final matches = name.contains(queryLower) || email.contains(queryLower);

        if (kDebugMode && matches) {
          debugPrint('✅ Match found: $name ($email)');
        }

        return matches;
      }).toList();

      if (kDebugMode) {
        debugPrint('✅ Filtered to ${filtered.length} users');
        debugPrint('🔍 ===== SEARCH END =====');
      }

      return filtered.map((json) => UserInfo.fromJson(json as Map<String, dynamic>)).toList();

    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Search error: $e');
        debugPrint('❌ Stack trace: $stackTrace');
        debugPrint('🔍 ===== SEARCH END =====');
      }
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // AI Chatbot
  // ═══════════════════════════════════════════════════════════════

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
      return response.data['response']?.toString() ?? response.data['reply']?.toString() ?? '';
    } catch (e) {
      if (kDebugMode) debugPrint('❌ AI Chatbot error: $e');
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<dynamic>> getAiChatbotHistory(String userId) async {
    try {
      final response = await _apiClient.get(ApiConstants.aiChatbotHistory(userId));
      return response.data['data'] ?? response.data ?? [];
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching AI history: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Legacy Support
  // ═══════════════════════════════════════════════════════════════

  Future<List<dynamic>> getChatRooms() async {
    try {
      final response = await _apiClient.get(ApiConstants.chatRooms);
      return response.data['data'] ?? response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}