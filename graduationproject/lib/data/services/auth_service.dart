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

  Future<AuthResponse> registerCompany(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiConstants.registerCompany,
      data: data,
    );
    final authResponse = AuthResponse.fromJson(response.data);
    await SecureStorage.saveToken(authResponse.token);
    return authResponse;
  }

  Future<AuthResponse> verifyLogin(String email, String code) async {
    final response = await _apiClient.post(
      ApiConstants.verifyLogin,
      data: {'email': email, 'code': code},
    );
    final authResponse = AuthResponse.fromJson(response.data);
    await SecureStorage.saveToken(authResponse.token);
    return authResponse;
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }

  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _apiClient.post(
      ApiConstants.resetPassword,
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );
  }

  // User Profile & Settings
  Future<List<User>> getAllUsers() async {
    final response = await _apiClient.get(ApiConstants.users);
    final List<dynamic> data = response.data;
    return data.map((json) => User.fromJson(json)).toList();
  }

  Future<User> getProfile() async {
    final response = await _apiClient.get(ApiConstants.userProfile);
    return User.fromJson(response.data);
  }

  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.patch(
      ApiConstants.userProfile,
      data: data,
    );
    return User.fromJson(response.data);
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    await _apiClient.patch(
      ApiConstants.userSettings,
      data: settings,
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _apiClient.patch(
      ApiConstants.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }
}
