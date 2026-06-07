class SupportContactRequest {
  final String name;
  final String email;
  final String subject;
  final String message;
  final String preferredContact;

  SupportContactRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.preferredContact,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'subject': subject,
    'message': message,
    'preferredContact': preferredContact,
  };
}

class HelpArticle {
  final String id;
  final String title;
  final String? content;
  final String? categoryId;

  HelpArticle({required this.id, required this.title, this.content, this.categoryId});

  factory HelpArticle.fromJson(Map<String, dynamic> json) {
    return HelpArticle(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'],
      categoryId: json['categoryId']?.toString(),
    );
  }
}
