import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../notification/notification_models.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  Future<void> subscribe(String fcmToken) async {
    await _apiClient.post(
      ApiConstants.subscribeNotifications,
      data: {'fcmToken': fcmToken},
    );
  }

  Future<List<AppNotification>> getNotifications() async {
    final response = await _apiClient.get(ApiConstants.notifications);
    final List<dynamic> data = response.data;
    return data.map((json) => AppNotification.fromJson(json)).toList();
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.patch(ApiConstants.readNotification(id));
  }

  Future<void> markAllAsRead() async {
    await _apiClient.patch(ApiConstants.readAllNotifications);
  }

  Future<void> deleteNotification(String id) async {
    await _apiClient.delete(ApiConstants.deleteNotification(id));
  }
}
