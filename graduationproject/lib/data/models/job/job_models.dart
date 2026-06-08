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
    // Map salaryMin and salaryMax back to salaryRange
    String salaryRange = 'Competitive';
    if (json['salaryMin'] != null || json['salaryMax'] != null) {
      final min = json['salaryMin'] != null ? '${json['salaryMin']}' : '';
      final max = json['salaryMax'] != null ? ' - ${json['salaryMax']}' : '';
      salaryRange = '$min$max';
    } else if (json['salaryRange'] != null) {
      salaryRange = json['salaryRange'].toString();
    }

    // Map jobType array back to type string
    String type = 'Full-Time';
    if (json['jobType'] is List && (json['jobType'] as List).isNotEmpty) {
      type = (json['jobType'] as List).join(' • ');
    } else if (json['type'] != null) {
      type = json['type'].toString();
    }

    return Job(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      companyId: json['companyId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? 'Unknown Company',
      companyLogoUrl: json['companyLogoUrl']?.toString(),
      location: json['address']?.toString() ?? json['location']?.toString() ?? 'Remote',
      salaryRange: salaryRange,
      type: type,
      description: json['description']?.toString() ?? '',
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      qualifications: List<String>.from(json['qualifications'] ?? []),
      niceToHaves: List<String>.from(json['niceToHaves'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      category: json['categoryId']?.toString() ?? json['category']?.toString() ?? 'General',
      tags: List<String>.from(json['skills'] ?? json['tags'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      requiredCount: json['slotsAvailable'] ?? json['requiredCount'] ?? 1,
      acceptedCount: json['acceptedCount'] ?? 0,
      deadline: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : (json['deadline'] != null ? DateTime.tryParse(json['deadline'].toString()) : null),
      status: json['isActive'] == true ? 'Active' : (json['isActive'] == false ? 'Closed' : (json['status']?.toString() ?? 'Active')),
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

  Map<String, dynamic> toJson() {
    int? salaryMin;
    int? salaryMax;
    if (salaryRange != null && salaryRange!.isNotEmpty) {
      // e.g. "10k - 20k" -> min: 10000, max: 20000
      final parts = salaryRange!.replaceAll(RegExp(r'[kK]'), '000').split('-');
      if (parts.isNotEmpty) salaryMin = int.tryParse(parts[0].replaceAll(RegExp(r'[^0-9]'), ''));
      if (parts.length > 1) salaryMax = int.tryParse(parts[1].replaceAll(RegExp(r'[^0-9]'), ''));
    }

    String finalDesc = description ?? '';
    if (responsibilities != null && responsibilities!.isNotEmpty) {
      finalDesc += '\n\nالمهام:\n- ${responsibilities!.join('\n- ')}';
    }
    if (qualifications != null && qualifications!.isNotEmpty) {
      finalDesc += '\n\nالمؤهلات:\n- ${qualifications!.join('\n- ')}';
    }
    if (niceToHaves != null && niceToHaves!.isNotEmpty) {
      finalDesc += '\n\nإضافات مفضلة:\n- ${niceToHaves!.join('\n- ')}';
    }

    List<String> combinedSkills = [];
    if (tags != null) combinedSkills.addAll(tags!);

    return {
      'title': title,
      if (finalDesc.isNotEmpty) 'description': finalDesc,
      if (location != null) 'address': location,
      if (salaryMin != null) 'salaryMin': salaryMin,
      if (salaryMax != null) 'salaryMax': salaryMax,
      if (type != null) 'jobType': [type!],
      if (benefits != null) 'benefits': benefits,
      if (requiredCount != null) 'slotsAvailable': requiredCount,
      if (deadline != null) 'expiresAt': deadline?.toIso8601String(),
      if (status != null) 'isActive': status?.toLowerCase() == 'active' || status?.toLowerCase() == 'نشط',
      if (combinedSkills.isNotEmpty) 'skills': combinedSkills,
    };
  }
}