import '../job/job_models.dart';

class JobApplication {
  final String id;
  final String jobId;
  final Job? job;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String status;
  final DateTime createdAt;
  final String? resumeUrl;
  final String? coverLetter;

  JobApplication({
    required this.id,
    required this.jobId,
    this.job,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.status,
    required this.createdAt,
    this.resumeUrl,
    this.coverLetter,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      jobId: json['jobId'],
      job: json['job'] != null ? Job.fromJson(json['job']) : null,
      userId: json['userId'].toString(),
      userName: json['userName'],
      userPhotoUrl: json['userPhotoUrl'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      resumeUrl: json['resumeUrl'],
      coverLetter: json['coverLetter'],
    );
  }
}

class CreateApplicationRequest {
  final String jobId;
  final String userName;
  final String? resumeUrl;
  final String? coverLetter;

  CreateApplicationRequest({
    required this.jobId,
    required this.userName,
    this.resumeUrl,
    this.coverLetter,
  });

  Map<String, dynamic> toJson() => {
    'jobId': jobId,
    'userName': userName,
    if (resumeUrl != null) 'resumeUrl': resumeUrl,
    if (coverLetter != null) 'coverLetter': coverLetter,
  };
}
