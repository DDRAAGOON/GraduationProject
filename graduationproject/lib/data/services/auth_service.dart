import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/secure_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../models/auth/auth_models.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    final authResponse = AuthResponse.fromJson(response.data);
    await SecureStorage.saveToken(authResponse.token);
    return authResponse;
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    final authResponse = AuthResponse.fromJson(response.data);
    await SecureStorage.saveToken(authResponse.token);
    return authResponse;
  }

  Future<void> verifyEmail(String email, String code) async {
    await _apiClient.post(
      ApiConstants.verifyEmail,
      data: {'email': email, 'code': code},
    );
  }

  Future<void> resendCode(String email) async {
    await _apiClient.post(
      ApiConstants.resendCode,
      data: {'email': email},
    );
  }

  Future<void> googleLogin(String token) async {
    final response = await _apiClient.post(
      ApiConstants.googleLogin,
      data: {'token': token},
    );
    final authResponse = AuthResponse.fromJson(response.data);
    await SecureStorage.saveToken(authResponse.token);
  }

  Future<String> uploadDocument(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _apiClient.post(
      ApiConstants.uploadDocument,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data['url'] ?? '';
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }

  // User Profile
  Future<User> getMe() async {
    final response = await _apiClient.get(ApiConstants.userMe);
    return User.fromJson(response.data);
  }

  Future<User> updateMe(Map<String, dynamic> data) async {
    final response = await _apiClient.put(
      ApiConstants.userMe,
      data: data,
    );
    return User.fromJson(response.data);
  }

  Future<void> updateTheme(String theme) async {
    await _apiClient.patch(
      ApiConstants.userTheme,
      data: {'theme': theme},
    );
  }

  Future<void> updateLanguage(String language) async {
    await _apiClient.patch(
      ApiConstants.userLanguage,
      data: {'language': language},
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _apiClient.put(
      ApiConstants.userPassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }
}
