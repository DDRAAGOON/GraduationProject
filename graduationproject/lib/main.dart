import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';
import 'data/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    final apiClient = ApiClient();
    final notificationService = NotificationService(apiClient);
    await notificationService.initialize();
  } catch (e) {
    if (kDebugMode) debugPrint('Firebase initialization failed: $e');
  }

  runApp(const App());
}
