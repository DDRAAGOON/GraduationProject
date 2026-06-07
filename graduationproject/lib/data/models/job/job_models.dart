class Job {
  final String id;
  final String title;
  final String companyId;
  final String companyName;
  final String? companyLogoUrl;
  final String location;
  final String salaryRange;
  final String type;
  final String description;
  final List<String> responsibilities;
  final List<String> qualifications;
  final List<String> niceToHaves;
  final List<String> benefits;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final int requiredCount;
  final int acceptedCount;
  final DateTime? deadline;
  final String status;

  Job({
    required this.id,
    required this.title,
    required this.companyId,
    required this.companyName,
    this.companyLogoUrl,
    required this.location,
    required this.salaryRange,
    required this.type,
    required this.description,
    required this.responsibilities,
    required this.qualifications,
    required this.niceToHaves,
    required this.benefits,
    required this.category,
    required this.tags,
    required this.createdAt,
    required this.requiredCount,
    required this.acceptedCount,
    this.deadline,
    required this.status,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyLogoUrl: json['companyLogoUrl'],
      location: json['location'],
      salaryRange: json['salaryRange'],
      type: json['type'],
      description: json['description'],
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      qualifications: List<String>.from(json['qualifications'] ?? []),
      niceToHaves: List<String>.from(json['niceToHaves'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      requiredCount: json['requiredCount'] ?? 1,
      acceptedCount: json['acceptedCount'] ?? 0,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      status: json['status'],
    );
  }
}

class CreateJobRequest {
  final String title;
  final String companyName;
  final String? location;
  final String? salaryRange;
  final String? type;
  final String? description;
  final List<String>? responsibilities;
  final List<String>? qualifications;
  final List<String>? niceToHaves;
  final List<String>? benefits;
  final String? category;
  final List<String>? tags;
  final int? requiredCount;
  final DateTime? deadline;
  final String? status;

  CreateJobRequest({
    required this.title,
    required this.companyName,
    this.location,
    this.salaryRange,
    this.type,
    this.description,
    this.responsibilities,
    this.qualifications,
    this.niceToHaves,
    this.benefits,
    this.category,
    this.tags,
    this.requiredCount,
    this.deadline,
    this.status,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'companyName': companyName,
    if (location != null) 'location': location,
    if (salaryRange != null) 'salaryRange': salaryRange,
    if (type != null) 'type': type,
    if (description != null) 'description': description,
    if (responsibilities != null) 'responsibilities': responsibilities,
    if (qualifications != null) 'qualifications': qualifications,
    if (niceToHaves != null) 'niceToHaves': niceToHaves,
    if (benefits != null) 'benefits': benefits,
    if (category != null) 'category': category,
    if (tags != null) 'tags': tags,
    if (requiredCount != null) 'requiredCount': requiredCount,
    if (deadline != null) 'deadline': deadline?.toIso8601String(),
    if (status != null) 'status': status,
  };
}
