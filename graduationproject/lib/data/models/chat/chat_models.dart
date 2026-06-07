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
  final String? photoUrl;

  UserInfo({required this.id, required this.name, this.photoUrl});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id']?.toString() ?? json['userId']?.toString() ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      photoUrl: json['photoUrl'] ?? json['picture'],
    );
  }
}
