import '../../shared/models/message_thread.dart';

final class MessageThreadDto {
  MessageThreadDto({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lastTimeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String lastTimeLabel;

  factory MessageThreadDto.fromJson(Map<String, dynamic> json) {
    return MessageThreadDto(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      lastTimeLabel: (json['lastTimeLabel'] ?? '').toString(),
    );
  }

  MessageThread toDomain() {
    return MessageThread(
      id: id,
      title: title,
      subtitle: subtitle,
      lastTimeLabelEn: lastTimeLabel,
      lastTimeLabelAr: lastTimeLabel,
    );
  }
}

