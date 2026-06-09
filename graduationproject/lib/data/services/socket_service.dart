import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../core/constants/api_constants.dart';
import '../models/chat/chat_models.dart';
import '../models/notification/notification_models.dart';

class SocketService {
  SocketService._();
  static final SocketService instance = SocketService._();

  IO.Socket? _socket;

  // Listeners
  final List<Function(ChatMessage)> _messageListeners = [];
  final List<Function(AppNotification)> _notificationListeners = [];

  void connect(String token) {
    if (_socket != null && _socket!.connected) return;

    try {
      _socket = IO.io(
        ApiConstants
            .baseUrl, // The base URL without /api, suitable for socket connection
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .build(),
      );

      _socket!.connect();

      _socket!.onConnect((_) {
        if (kDebugMode) debugPrint('🟢 WebSocket Connected');
      });

      _socket!.onDisconnect((_) {
        if (kDebugMode) debugPrint('🔴 WebSocket Disconnected');
      });

      _socket!.on('newMessage', (data) {
        if (kDebugMode) debugPrint('📩 New message received via Socket: $data');
        if (data != null) {
          try {
            final msg = ChatMessage.fromJson(data);
            for (var listener in _messageListeners) {
              listener(msg);
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing socket message: $e');
          }
        }
      });

      _socket!.on('newNotification', (data) {
        if (kDebugMode)
          debugPrint('🔔 New notification received via Socket: $data');
        if (data != null) {
          try {
            final notif = AppNotification.fromJson(data);
            for (var listener in _notificationListeners) {
              listener(notif);
            }
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing socket notification: $e');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) debugPrint('WebSocket connection error: $e');
    }
  }

  void joinRoom(String roomId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('joinRoom', roomId);
      if (kDebugMode) debugPrint('Joined socket room: $roomId');
    }
  }

  void onMessage(Function(ChatMessage) callback) {
    _messageListeners.add(callback);
  }

  void removeMessageListener(Function(ChatMessage) callback) {
    _messageListeners.remove(callback);
  }

  void onNotification(Function(AppNotification) callback) {
    _notificationListeners.add(callback);
  }

  void removeNotificationListener(Function(AppNotification) callback) {
    _notificationListeners.remove(callback);
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      if (kDebugMode)
        debugPrint('WebSocket completely disconnected & disposed');
    }
  }
}
