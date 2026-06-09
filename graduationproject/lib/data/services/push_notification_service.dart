import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/push/push_models.dart';

class PushNotificationService {
  final ApiClient _apiClient;

  PushNotificationService(this._apiClient);

  Future<void> registerFcm(PushRegistration registration) async {
    try {
      await _apiClient.post(
        ApiConstants.pushRegisterFcm,
        data: registration.toJson(),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<dynamic>> getSubscriptions(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.pushSubscriptions(userId),
      );
      return response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> getVapidKey() async {
    try {
      final response = await _apiClient.get(ApiConstants.pushVapidKey);
      return response.data['publicKey'] ?? '';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
