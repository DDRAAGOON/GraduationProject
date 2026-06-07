class Company {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? description;
  final String? website;
  final String? location;
  final String status;

  Company({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.description,
    this.website,
    this.location,
    required this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      description: json['description'],
      website: json['website'],
      location: json['location'],
      status: json['status'] ?? 'Active',
    );
  }
}
