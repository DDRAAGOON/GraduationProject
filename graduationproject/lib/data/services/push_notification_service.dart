import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/push/push_models.dart';

class PushNotificationService {
  final ApiClient _apiClient;

  PushNotificationService(this._apiClient);

  Future<void> registerFcm(PushRegistration registration) async {
    await _apiClient.post(
      ApiConstants.pushRegisterFcm,
      data: registration.toJson(),
    );
  }

  Future<List<dynamic>> getSubscriptions(String userId) async {
    final response = await _apiClient.get(ApiConstants.pushSubscriptions(userId));
    return response.data;
  }

  Future<String> getVapidKey() async {
    final response = await _apiClient.get(ApiConstants.pushVapidKey);
    return response.data['publicKey'] ?? '';
  }
}
