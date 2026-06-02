// Base URL placeholder and REST path constants for the backend.

final class ApiEndpoints {
  const ApiEndpoints._();

  // Railway deployment URL
  static const String baseUrl = 'https://jobito-api-production.up.railway.app';

  // Auth
  static const String login = '/api/auth/login';
  static const String verifyLogin = '/api/auth/verify-login';
  static const String googleLogin = '/api/auth/google';
  static const String register = '/api/auth/register';
  static const String registerCompany = '/api/auth/register-company';
  static const String sendPhoneOtp = '/api/auth/send-phone-otp';
  static const String verifyPhone = '/api/auth/verify-phone';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';

  // Users
  static const String users = '/api/users';
  static const String profile = '/api/users/profile';
  static const String settings = '/api/users/settings';
  static const String changePassword = '/api/users/change-password';

  // Recruitment entities
  static const String jobs = '/api/jobs';
  static const String applications = '/api/applications';
  static const String applicationStatus = '/api/applications/{id}/status';
  static const String messages = '/api/messages';
  static const String notifications = '/api/notifications';
}

