import '../../data/api/api_client.dart';

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  Future<void> registerFCMToken(String userId, String token, {String deviceName = 'Flutter App'}) async {
    try {
      final response = await ApiClient.post(
        '/push/register/fcm',
        requiresAuth: true,
        body: {
          'userId': userId,
          'deviceToken': token,
          'deviceName': deviceName,
        },
      );
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
