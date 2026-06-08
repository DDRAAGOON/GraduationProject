import 'dart:async';
import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';
import 'session_manager.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        body: {'email': email.trim(), 'password': password},
      );

      final data = await handleResponse(response, (map) => map);
      final token =
          data['token']?.toString() ?? data['access_token']?.toString();
      final user = data['user'] as Map<String, dynamic>?;

      if (token != null) {
        await ApiClient.saveToken(token);
      }

      if (user != null) {
        final userId = user['id']?.toString();
        if (userId != null && userId.isNotEmpty) {
          await ApiClient.saveUserId(userId);
        }

        final name =
            user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
        final emailStr = user['email']?.toString() ?? '';

        RecruitmentSyncStore.instance.updateCurrentUser(
          name: name,
          email: emailStr,
        );

        await SessionManager.saveUserSession(email: emailStr, name: name);
      }
      return user ?? {};
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      final response = await ApiClient.post(
        '/auth/google-login',
        body: {'token': idToken},
      );

      final data = await handleResponse(response, (map) => map);
      final token = data['access_token']?.toString();
      final user = data['user'] as Map<String, dynamic>?;

      if (token != null) {
        await ApiClient.saveToken(token);
      }

      if (user != null) {
        final userId = user['id']?.toString();
        if (userId != null && userId.isNotEmpty) {
          await ApiClient.saveUserId(userId);
        }

        final name =
            user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
        final emailStr = user['email']?.toString() ?? '';

        RecruitmentSyncStore.instance.updateCurrentUser(
          name: name,
          email: emailStr,
        );

        await SessionManager.saveUserSession(email: emailStr, name: name);
      }

      return user ?? {};
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/register',
        body: {
          'email': email.trim(),
          'password': password,
          'fullName': fullName.trim(),
          'role': role.toLowerCase().trim(),
          'phone': ?phone,
        },
      );

      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/verify-email',
        body: {'email': email.trim(), 'otp': otp.trim(), 'code': otp.trim()},
      );
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await ApiClient.post(
        '/auth/forgot-password',
        body: {'email': email.trim()},
      );
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/reset-password',
        body: {
          'email': email.trim(),
          'code': code.trim(),
          'newPassword': newPassword,
        },
      );
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadDocument(String filePath) async {
    try {
      final response = await ApiClient.multipartRequest(
        '/auth/upload-document',
        method: 'POST',
        files: {'file': filePath},
        requiresAuth: true,
      );
      final data = await handleResponse(response, (map) => map);
      return data['url']?.toString() ?? data['imageUrl']?.toString();
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await ApiClient.clearToken();
  }
}
