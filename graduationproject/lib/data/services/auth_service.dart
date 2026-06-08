import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/network/secure_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../models/auth/auth_models.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      final authResponse = AuthResponse.fromJson(response.data);
      await SecureStorage.saveToken(authResponse.token);
      return authResponse;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      final authResponse = AuthResponse.fromJson(response.data);
      await SecureStorage.saveToken(authResponse.token);
      return authResponse;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> verifyEmail(String email, String code) async {
    try {
      await _apiClient.post(
        ApiConstants.verifyEmail,
        data: {'email': email, 'code': code},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> resendCode(String email) async {
    try {
      await _apiClient.post(
        ApiConstants.resendCode,
        data: {'email': email},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> googleLogin(String token) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.googleLogin,
        data: {'token': token},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      await SecureStorage.saveToken(authResponse.token);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> uploadDocument(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });
      final response = await _apiClient.post(
        ApiConstants.uploadDocument,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response.data['url'] ?? '';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> logout() async {
    try {
      await SecureStorage.deleteToken();
    } catch (_) {
      // Always complete logout even if storage fails.
    }
  }

  // User Profile
  Future<User> getMe() async {
    try {
      final response = await _apiClient.get(ApiConstants.userMe);
      return User.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<User> updateMe(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.userMe,
        data: data,
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updateTheme(String theme) async {
    try {
      await _apiClient.patch(
        ApiConstants.userTheme,
        data: {'theme': theme},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updateLanguage(String language) async {
    try {
      await _apiClient.patch(
        ApiConstants.userLanguage,
        data: {'language': language},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _apiClient.put(
        ApiConstants.userPassword,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
