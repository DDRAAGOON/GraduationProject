import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/notification/notification_models.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  Future<void> subscribe(String fcmToken) async {
    try {
      await _apiClient.post(
        ApiConstants.subscribeNotifications,
        data: {'fcmToken': fcmToken},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await _apiClient.get(ApiConstants.notifications);
      final List<dynamic> data = response.data;
      return data.map((json) => AppNotification.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _apiClient.patch(ApiConstants.readNotification(id));
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiClient.patch(ApiConstants.readAllNotifications);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _apiClient.delete(ApiConstants.deleteNotification(id));
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
