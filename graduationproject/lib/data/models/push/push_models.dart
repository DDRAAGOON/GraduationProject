class PushRegistration {
  final String? userId;
  final String deviceToken;
  final String deviceName;

  PushRegistration({this.userId, required this.deviceToken, required this.deviceName});

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'deviceToken': deviceToken,
    'deviceName': deviceName,
  };
}
