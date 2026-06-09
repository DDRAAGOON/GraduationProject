import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/notification/notification_models.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    debugPrint("Handling a background message: ${message.messageId}");
  }
}

class NotificationService {
  final ApiClient _apiClient;

  // Singleton instance logic (requires passing ApiClient upon first initialization)
  static NotificationService? _instance;

  NotificationService._(this._apiClient) {
    _messaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();
  }

  factory NotificationService(ApiClient apiClient) {
    _instance ??= NotificationService._(apiClient);
    return _instance!;
  }

  static NotificationService get instance {
    if (_instance == null) {
      throw Exception(
        'NotificationService must be initialized with ApiClient first',
      );
    }
    return _instance!;
  }

  late final FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;

  bool _initialized = false;
  String? _fcmToken;

  // ═══════════════════════════════════════════════════════════════
  // FCM & Local Notifications Setup
  // ═══════════════════════════════════════════════════════════════

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 1. Request permissions for iOS
      await _requestPermissions();

      // 2. Configure local notifications for foreground display
      const androidInitialize = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosInitialize = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidInitialize,
        iOS: iosInitialize,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // 3. Set background messaging handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // 4. Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) debugPrint('Got a message whilst in the foreground!');
        if (message.notification != null) {
          showLocalNotification(
            title: message.notification!.title ?? 'New Notification',
            body: message.notification!.body ?? '',
            payload: message.data.toString(),
          );
        }
      });

      // 5. Handle app opened from terminated state
      final initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        _handleMessageAction(initialMessage.data);
      }

      // 6. Handle app opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessageAction(message.data);
      });

      _initialized = true;
    } catch (e) {
      if (kDebugMode) debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    }
  }

  Future<String?> getDeviceToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      if (kDebugMode) debugPrint('FCM Token: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> registerToken() async {
    final token = await getDeviceToken();
    if (token == null) return;

    try {
      await _apiClient.post(
        ApiConstants.pushRegisterFcm,
        data: {'token': token, 'platform': Platform.isIOS ? 'ios' : 'android'},
      );
      if (kDebugMode) debugPrint('FCM Token registered successfully');
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to register FCM token: $e');
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      if (kDebugMode)
        debugPrint('Notification tapped with payload: ${response.payload}');
    }
  }

  void _handleMessageAction(Map<String, dynamic> data) {
    if (kDebugMode) debugPrint('Handling background message action: $data');
  }

  // ═══════════════════════════════════════════════════════════════
  // Backend API Calls
  // ═══════════════════════════════════════════════════════════════

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
