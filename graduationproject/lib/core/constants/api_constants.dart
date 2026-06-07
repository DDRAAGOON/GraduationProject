class ApiConstants {
  static const String baseUrl = 'https://jobito-api-production.up.railway.app';
  static const String apiPrefix = '/api';

  // Auth
  static const String register = '$apiPrefix/auth/register';
  static const String login = '$apiPrefix/auth/login';
  static const String verifyLogin = '$apiPrefix/auth/verify-login';
  static const String registerCompany = '$apiPrefix/auth/register-company';
  static const String forgotPassword = '$apiPrefix/auth/forgot-password';
  static const String resetPassword = '$apiPrefix/auth/reset-password';

  // Users
  static const String users = '$apiPrefix/users';
  static const String userProfile = '$apiPrefix/users/profile';
  static const String userSettings = '$apiPrefix/users/settings';
  static const String changePassword = '$apiPrefix/users/change-password';

  // Jobs
  static const String jobs = '$apiPrefix/jobs';
  static String companyJobs(String companyId) => '$apiPrefix/jobs/company/$companyId';
  static const String jobStats = '$apiPrefix/jobs/applications/stats';
  static String jobDetails(String id) => '$apiPrefix/jobs/$id';

  // Applications
  static const String applications = '$apiPrefix/applications';
  static const String myApplications = '$apiPrefix/applications/my-applications';
  static String jobApplications(String jobId) => '$apiPrefix/applications/job/$jobId';
  static String applicationDetails(String id) => '$apiPrefix/applications/$id';
  static String applicationStatus(String id) => '$apiPrefix/applications/$id/status';

  // Companies
  static const String companies = '$apiPrefix/companies';
  static const String pendingCompanies = '$apiPrefix/companies/pending';
  static String companyDetails(String id) => '$apiPrefix/companies/$id';
  static String updateCompanyStatus(String id) => '$apiPrefix/companies/$id/status';

  // Notifications
  static const String subscribeNotifications = '$apiPrefix/notifications/subscribe';
  static const String notifications = '$apiPrefix/notifications';
  static String readNotification(String id) => '$apiPrefix/notifications/$id/read';
  static const String readAllNotifications = '$apiPrefix/notifications/read-all';
  static String deleteNotification(String id) => '$apiPrefix/notifications/$id';

  // Chat & AI
  static const String chatRooms = '$apiPrefix/chat/rooms';
  static String chatMessages(String roomId) => '$apiPrefix/chat/rooms/$roomId/messages';
  static const String aiChat = '$apiPrefix/ai-chatbot/chat';
  static String aiHistory(String userId) => '$apiPrefix/ai-chatbot/history/$userId';

  // Images
  static const String uploadImage = '$apiPrefix/images/upload';
  static const String updateProfileImage = '$apiPrefix/images/profile';
  static const String updateBannerImage = '$apiPrefix/images/banner';
  static String entityImages(String type, String id) => '$apiPrefix/images/entity/$type/$id';
  static String userProfileImage(String userId) => '$apiPrefix/images/profile/$userId';
  static String deleteImage(String imageId) => '$apiPrefix/images/$imageId';

  // Favorites
  static String toggleFavorite(String jobId) => '$apiPrefix/favorites/toggle/$jobId';
  static const String favorites = '$apiPrefix/favorites';

  // Dashboard
  static const String dashboardStats = '$apiPrefix/dashboard/stats';
  static const String applicantsSummary = '$apiPrefix/dashboard/applicants-summary';
}
