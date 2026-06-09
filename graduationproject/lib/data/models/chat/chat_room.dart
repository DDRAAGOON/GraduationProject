import '../../../core/constants/api_constants.dart';

class ChatRoom {
  final String id;
  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String recipientId;

  ChatRoom({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.recipientId,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['avatarUrl'] ?? json['photoUrl'] ?? json['logoUrl'];
    if (photoUrl != null && photoUrl.trim().isNotEmpty) {
      if (!photoUrl.startsWith('http://') && !photoUrl.startsWith('https://')) {
        photoUrl =
            '${ApiConstants.baseUrl}${photoUrl.startsWith('/') ? '' : '/'}$photoUrl';
      }
    }

    return ChatRoom(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name:
          json['name']?.toString() ?? json['fullName']?.toString() ?? 'Unknown',
      avatarUrl: photoUrl,
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.tryParse(json['lastMessageTime']) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: int.tryParse(json['unreadCount']?.toString() ?? '0') ?? 0,
      recipientId: json['recipientId']?.toString() ?? '',
    );
  }
}
