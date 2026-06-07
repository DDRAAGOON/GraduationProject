class ApiConstants {
  static const String baseUrl = 'https://jobito-api-production.up.railway.app';
  static const String apiPrefix = '/api';

  // Auth & Users
  static const String register = '$apiPrefix/auth/register';
  static const String login = '$apiPrefix/auth/login';
  static const String verifyLogin = '$apiPrefix/auth/verify-login';
  static const String registerCompany = '$apiPrefix/auth/register-company';
  static const String verifyEmail = '$apiPrefix/auth/verify-email';
  static const String resendCode = '$apiPrefix/auth/resend-code';
  static const String forgotPassword = '$apiPrefix/auth/forgot-password';
  static const String resetPassword = '$apiPrefix/auth/reset-password';
  static const String googleLogin = '$apiPrefix/auth/google-login';
  static const String refreshToken = '$apiPrefix/auth/refresh-token';
  static const String uploadDocument = '$apiPrefix/auth/upload-document';

  static const String users = '$apiPrefix/users';
  static const String userProfile = '$apiPrefix/users/profile';
  static const String userMe = '$apiPrefix/users/me';
  static const String userSettings = '$apiPrefix/users/settings';
  static const String changePassword = '$apiPrefix/users/change-password';
  static const String userTheme = '$apiPrefix/users/me/theme';
  static const String userLanguage = '$apiPrefix/users/me/language';
  static const String userPassword = '$apiPrefix/users/me/password';
  static const String userDeletion = '$apiPrefix/users/me';
  static const String userDeletionStatus = '$apiPrefix/users/me/deletion-status';
  static String userById(String id) => '$apiPrefix/users/$id';

  // Jobs
  static const String jobs = '$apiPrefix/jobs';
  static String companyJobs(String companyId) => '$apiPrefix/jobs/company/$companyId';
  static const String jobStats = '$apiPrefix/jobs/applications/stats';
  static const String jobCategories = '$apiPrefix/jobs/categories';
  static const String nearbyJobs = '$apiPrefix/jobs/nearby';
  static String jobById(String id) => '$apiPrefix/jobs/$id';
  static String similarJobs(String id) => '$apiPrefix/jobs/similar/$id';
  static String jobAnalytics(String id) => '$apiPrefix/jobs/$id/analytics';
  static String jobView(String id) => '$apiPrefix/jobs/$id/view';

  // Applications
  static const String applications = '$apiPrefix/applications';
  static const String myApplications = '$apiPrefix/applications/my';
  static const String oldMyApplications = '$apiPrefix/applications/my-applications';
  static String jobApplications(String jobId) => '$apiPrefix/applications/job/$jobId';
  static String applicationById(String id) => '$apiPrefix/applications/$id';
  static String applicationStatus(String id) => '$apiPrefix/applications/$id/status';
  static String applicationCheckStatus(String jobId) => '$apiPrefix/applications/status/$jobId';

  // Companies
  static const String companies = '$apiPrefix/companies';
  static const String pendingCompanies = '$apiPrefix/companies/pending';
  static String companyById(String id) => '$apiPrefix/companies/$id';
  static String updateCompanyStatus(String id) => '$apiPrefix/companies/$id/status';
  static const String myCompanyProfile = '$apiPrefix/companies/my/profile';
  static const String myCompanyDashboard = '$apiPrefix/companies/my/dashboard-summary';
  static String companyStats(String id) => '$apiPrefix/companies/$id/statistics';

  // Notifications
  static const String notifications = '$apiPrefix/notifications';
  static const String subscribeNotifications = '$apiPrefix/notifications/subscribe';
  static String readNotification(String id) => '$apiPrefix/notifications/$id/read';
  static const String readAllNotifications = '$apiPrefix/notifications/read-all';
  static String deleteNotification(String id) => '$apiPrefix/notifications/$id';

  // Chat
  static const String chatRooms = '$apiPrefix/chat/rooms';
  static String chatMessages(String roomId) => '$apiPrefix/chat/rooms/$roomId/messages';
  static const String chatP2P = '$apiPrefix/chat/p2p';
  static const String chatHistory = '$apiPrefix/chat/p2p/history';
  static String myChats(String userId) => '$apiPrefix/chat/my-chats/$userId';
  static const String chatRead = '$apiPrefix/chat/p2p/read';
  static const String chatUpload = '$apiPrefix/chat/upload';
  static const String chatUploadAudio = '$apiPrefix/chat/upload-audio';
  static String chatMedia(String fileName) => '$apiPrefix/chat/media/$fileName';
  static const String chatSearchUsers = '$apiPrefix/chat/search-users';
  static String chatUserInfo(String userId) => '$apiPrefix/chat/user-info/$userId';

  // AI Smart & Chatbot
  static const String aiSmartSearch = '$apiPrefix/ai/smart-search';
  static const String aiAutoTag = '$apiPrefix/ai/auto-tag';
  static const String aiScoreCv = '$apiPrefix/ai/score-cv';
  static const String aiGenerateJobDesc = '$apiPrefix/ai/generate-job-desc';
  static const String aiCoverLetter = '$apiPrefix/ai/cover-letter';
  static const String aiChat = '$apiPrefix/ai-chatbot/chat';
  static const String aiChatbot = '$apiPrefix/ai-chatbot/chat';
  static String aiHistory(String userId) => '$apiPrefix/ai-chatbot/history/$userId';
  static String aiChatbotHistory(String userId) => '$apiPrefix/ai-chatbot/history/$userId';

  // Images
  static const String uploadImage = '$apiPrefix/images/upload';
  static const String updateProfileImage = '$apiPrefix/images/profile';
  static const String updateBannerImage = '$apiPrefix/images/banner';
  static String entityImages(String type, String id) => '$apiPrefix/images/entity/$type/$id';
  static String userProfileImage(String userId) => '$apiPrefix/images/profile/$userId';
  static String deleteImage(String imageId) => '$apiPrefix/images/$imageId';

  // Push Notifications
  static const String pushRegisterFcm = '$apiPrefix/push/register/fcm';
  static const String pushRegisterWeb = '$apiPrefix/push/register/web';
  static String pushSubscriptions(String userId) => '$apiPrefix/push/subscriptions/$userId';
  static const String pushVapidKey = '$apiPrefix/push/vapid-key';

  // Support & Dashboard
  static const String supportHelpCategories = '$apiPrefix/support/help/categories';
  static const String supportHelpArticles = '$apiPrefix/support/help/articles';
  static String supportHelpArticleById(String id) => '$apiPrefix/support/help/articles/$id';
  static const String supportContact = '$apiPrefix/support/contact';
  static const String contentServices = '$apiPrefix/content/services';
  static const String contentFeatures = '$apiPrefix/content/features';
  static const String contentStats = '$apiPrefix/content/stats';
  static const String dashboardStats = '$apiPrefix/dashboard/stats';
  static const String applicantsSummary = '$apiPrefix/dashboard/applicants-summary';

  // Favorites
  static String toggleFavorite(String jobId) => '$apiPrefix/favorites/toggle/$jobId';
  static const String favorites = '$apiPrefix/favorites';
}
