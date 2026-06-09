class ChatbotMessage {
  final String id;
  final String message;
  final String response;
  final DateTime timestamp;
  final String userId;

  ChatbotMessage({
    required this.id,
    required this.message,
    required this.response,
    required this.timestamp,
    required this.userId,
  });

  factory ChatbotMessage.fromJson(Map<String, dynamic> json) {
    return ChatbotMessage(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      response: json['response']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      userId: json['userId']?.toString() ?? '',
    );
  }
}
