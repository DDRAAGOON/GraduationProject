import '../../../core/constants/api_constants.dart';

class ChatP2PRequest {
  final String? senderId;
  final String recipientId;
  final String content;
  final String type; // text, image, audio, file

  ChatP2PRequest({
    this.senderId,
    required this.recipientId,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    if (senderId != null) 'senderId': senderId,
    'recipientId': recipientId,
    'content': content,
    'type': type,
  };
}

class ChatMessage {
  final String id;
  final String senderId;
  final String? recipientId;
  final String content;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.recipientId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      recipientId: json['recipientId']?.toString(),
      content: json['content'] ?? json['text'] ?? '',
      type: json['type'] ?? 'text',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
    );
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? photoUrl;

  UserInfo({
    required this.id,
    required this.name,
    this.email = '',
    this.role,
    this.photoUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ??
        json['userId']?.toString() ??
        json['_id']?.toString() ?? '';

    final name = json['fullName'] ??
        json['name'] ??
        json['username'] ??
        'Unknown';

    final email = json['email'] ?? '';
    final role = json['role']?.toString();

    // ✅ معالجة صحيحة للـ photoUrl باستخدام ApiConstants
    String? rawPhotoUrl = json['avatarUrl'] ??
        json['photoUrl'] ??
        json['picture'] ??
        json['avatar'];

    String? photoUrl;
    if (rawPhotoUrl != null && rawPhotoUrl.toString().trim().isNotEmpty) {
      final url = rawPhotoUrl.toString().trim();

      if (url.startsWith('http://') || url.startsWith('https://')) {
        // ✅ URL كامل بالفعل
        photoUrl = url;
      } else if (url.startsWith('/')) {
        // ✅ مسار نسبي - نضيف الـ base URL
        photoUrl = '${ApiConstants.baseUrl}$url';
      } else {
        // ✅ مسار بدون / في البداية
        photoUrl = '${ApiConstants.baseUrl}/$url';
      }
    }

    return UserInfo(
      id: id,
      name: name,
      email: email,
      role: role,
      photoUrl: photoUrl,
    );
  }
}