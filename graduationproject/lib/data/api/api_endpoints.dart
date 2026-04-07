// Base URL placeholder and REST path constants for the backend.

final class ApiEndpoints {
  const ApiEndpoints._();

  // TODO: Replace with your real backend base URL.
  static const String baseUrl = 'https://api.example.com';

  // Company / Jobs
  static const String jobs = '/company/jobs';
  static const String applicants = '/company/applicants';
  static const String applicantsByJob = '/company/jobs/{jobId}/applicants';

  // Messages
  static const String threads = '/company/threads';
}

