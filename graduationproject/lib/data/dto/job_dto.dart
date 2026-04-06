import '../../shared/models/job.dart';

final class JobDto {
  JobDto({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.employmentType,
    required this.category,
    required this.salaryRange,
    this.appliedCount,
    this.capacity,
  });

  final String id;
  final String title;
  final String companyName;
  final String location;
  final String employmentType;
  final String category;
  final String salaryRange;
  final int? appliedCount;
  final int? capacity;

  factory JobDto.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    return JobDto(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      companyName: (json['companyName'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      employmentType: (json['employmentType'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      salaryRange: (json['salaryRange'] ?? '').toString(),
      appliedCount: asInt(json['appliedCount']),
      capacity: asInt(json['capacity']),
    );
  }

  Job toDomain() {
    return Job(
      id: id,
      title: title,
      companyName: companyName,
      location: location,
      employmentType: employmentType,
      category: category,
      salaryRange: salaryRange,
      appliedCount: appliedCount,
      capacity: capacity,
    );
  }
}

