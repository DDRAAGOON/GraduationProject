final class MessageThread {
  MessageThread({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lastTimeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String lastTimeLabel;

  static MessageThread mock() => MessageThread(
        id: 'thread_1',
        title: 'Jan Mayer',
        subtitle: 'We want to invite you for a quick interview...',
        lastTimeLabel: '12 mins ago',
      );

  static List<MessageThread> mockList() => [
        mock(),
        MessageThread(
          id: 'thread_2',
          title: 'Angelina Swann',
          subtitle: 'Hey thanks for your interview...',
          lastTimeLabel: '3:40 PM',
        ),
        MessageThread(
          id: 'thread_3',
          title: 'James Gardner',
          subtitle: 'Hey thanks for your interview...',
          lastTimeLabel: '3:40 PM',
        ),
      ];
}

