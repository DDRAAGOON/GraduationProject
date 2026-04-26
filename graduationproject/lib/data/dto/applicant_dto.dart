// Map/JSON helpers around [Applicant] for API integration.

import '../../shared/models/applicant.dart';

final class ApplicantDto {
  ApplicantDto({
    required this.id,
    required this.fullName,
    required this.role,
    required this.rating,
    required this.stage,
    required this.email,
    required this.phone,
    required this.location,
    required this.appliedDateLabel,
    required this.jobId,
  });

  final String id;
  final String fullName;
  final String role;
  final double rating;
  final String stage;
  final String email;
  final String phone;
  final String location;
  final String appliedDateLabel;
  final String jobId;

  factory ApplicantDto.fromJson(Map<String, dynamic> json) {
    double asDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return ApplicantDto(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      rating: asDouble(json['rating']),
      stage: (json['stage'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      appliedDateLabel: (json['appliedDateLabel'] ?? '').toString(),
      jobId: (json['jobId'] ?? 'job_1').toString(),
    );
  }

  Applicant toDomain() {
    return Applicant(
      id: id,
      fullName: fullName,
      role: role,
      rating: rating,
      stage: stage,
      email: email,
      phone: phone,
      location: location,
      appliedDateLabel: appliedDateLabel,
      jobId: jobId,
    );
  }
}

