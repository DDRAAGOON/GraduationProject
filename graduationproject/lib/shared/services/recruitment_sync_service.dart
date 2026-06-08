import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_error_handler.dart';
import '../../core/network/secure_storage.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/job_service.dart';
import '../../data/services/application_service.dart';
import '../../data/services/chat_service.dart';
import '../../data/models/auth/auth_models.dart';
import '../../data/models/job/job_models.dart';
import '../../data/models/application/application_models.dart';
import '../state/company_store.dart';
import '../state/recruitment_sync_store.dart';
import 'session_manager.dart';

class RecruitmentSyncService {
  RecruitmentSyncService._() {
    _apiClient = ApiClient();
    _authService = AuthService(_apiClient);
    _jobService = JobService(_apiClient);
    _applicationService = ApplicationService(_apiClient);
    _chatService = ChatService(_apiClient);
  }

  static final RecruitmentSyncService instance = RecruitmentSyncService._();

  late final ApiClient _apiClient;
  late final AuthService _authService;
  late final JobService _jobService;
  late final ApplicationService _applicationService;
  late final ChatService _chatService;

  Timer? _timer;

  Future<bool> get isAuthenticated async {
    final token = await SecureStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      await _authService.googleLogin(idToken);
      final user = await _authService.getMe();
      return {
        'id': user.id,
        'role': user.role,
        'fullName': user.fullName,
        'email': user.email,
        'photoUrl': user.photoUrl,
      };
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<User?> login({
    required String email,
    required String password,
    String? expectedRole,
  }) async {
    try {
      final authResponse = await _authService.login(
        LoginRequest(email: email, password: password),
      );
      return authResponse.user;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> loginLegacy({
    required String email,
    required String password,
    String? expectedRole,
  }) async {
    try {
      final authResponse = await _authService.login(
        LoginRequest(email: email, password: password),
      );

      final user = authResponse.user;

      RecruitmentSyncStore.instance.updateCurrentUser(
        name: user.fullName ?? '',
        email: user.email,
        photoUrl: user.photoUrl,
      );

      if (user.role == 'company') {
        CompanyStore.instance.setRegistrationData(
          companyId: user.id,
          companyName: user.fullName ?? '',
          email: user.email,
        );
        final fullProfile = await SessionManager.getCompanyFullProfile();
        await CompanyStore.instance.loadFromSession(fullProfile);
      }

      return {
        'id': user.id,
        'role': user.role,
        'fullName': user.fullName,
        'name': user.fullName,
        'email': user.email,
        'photoUrl': user.photoUrl,
      };
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String phone = '',
  }) async {
    try {
      final authResponse = await _authService.register(
        RegisterRequest(email: email, password: password, fullName: name, role: role, phone: phone),
      );
      return authResponse.user;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<User> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      final user = await _authService.updateMe({
        'fullName': name,
        'photoUrl': photoUrl,
      }..removeWhere((_, v) => v == null));

      RecruitmentSyncStore.instance.updateCurrentUser(
        name: user.fullName ?? '',
        photoUrl: user.photoUrl,
      );

      return user;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updateStatus({
    required String applicationId,
    required String status,
  }) async {
    try {
      await _applicationService.updateApplicationStatus(applicationId, status);
      await _pullServerState();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error updating status: $e');
    }
  }

  Future<void> updateJob({
    required String jobId,
    required String title,
    required String companyName,
    required String location,
    required String salaryRange,
    required String type,
    required String description,
    required List<String> responsibilities,
    required List<String> qualifications,
    required List<String> niceToHaves,
    required List<String> benefits,
    required String category,
    required List<String> tags,
    required int requiredCount,
    DateTime? deadline,
    String? status,
  }) async {
    try {
      await _jobService.updateJob(
        jobId,
        CreateJobRequest(
          title: title,
          companyName: companyName,
          location: location,
          salaryRange: salaryRange,
          type: type,
          description: description,
          responsibilities: responsibilities,
          qualifications: qualifications,
          niceToHaves: niceToHaves,
          benefits: benefits,
          category: category,
          tags: tags,
          requiredCount: requiredCount,
          deadline: deadline,
          status: status,
        ),
      );
      await _pullServerState();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error updating job: $e');
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _jobService.deleteJob(jobId);
      await _pullServerState();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error deleting job: $e');
    }
  }

  Future<String> postJob({
    required String title,
    String companyName = 'Company',
    required String location,
    required String salaryRange,
    String type = 'Full-time',
    required String description,
    required List<String> responsibilities,
    required List<String> qualifications,
    List<String> niceToHaves = const [],
    required List<String> benefits,
    String category = 'Technical',
    List<String> tags = const [],
    int requiredCount = 1,
    DateTime? deadline,
  }) async {
    try {
      final job = await _jobService.createJob(
        CreateJobRequest(
          title: title,
          companyName: companyName,
          location: location,
          salaryRange: salaryRange,
          type: type,
          description: description,
          responsibilities: responsibilities,
          qualifications: qualifications,
          niceToHaves: niceToHaves,
          benefits: benefits,
          category: category,
          tags: tags,
          requiredCount: requiredCount,
          deadline: deadline,
        ),
      );
      await _pullServerState();
      return job.id;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> applyToJob({
    required String jobId,
    required String userName,
  }) async {
    try {
      await _applicationService.applyForJob(
        CreateApplicationRequest(jobId: jobId, userName: userName),
      );
      await _pullServerState();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error applying to job: $e');
    }
  }

  Future<void> startPolling() async {
    try {
      await CompanyStore.instance.initFromSession();
    } catch (_) {}
    await _pullServerState();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 12), (_) async {
      await _pullServerState();
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  /// ✅ الدالة المصححة - كل طلب يتم معالجته بشكل منفصل
  Future<void> _pullServerState() async {
    if (!await isAuthenticated) {
      if (kDebugMode) debugPrint('⚠️ Not authenticated, skipping pull');
      return;
    }

    if (kDebugMode) debugPrint('🔄 Pulling server state...');

    List<Map<String, dynamic>> jobs = [];
    List<Map<String, dynamic>> applications = [];
    List<Map<String, dynamic>> messages = [];

    // ✅ جلب الوظائف - بشكل منفصل
    try {
      final jobsResponse = await _apiClient.get(ApiConstants.jobs);
      final jobsData = jobsResponse.data;

      if (jobsData is List) {
        jobs = jobsData.cast<Map<String, dynamic>>();
      } else if (jobsData is Map && jobsData['data'] is List) {
        jobs = (jobsData['data'] as List).cast<Map<String, dynamic>>();
      }

      if (kDebugMode) debugPrint('✅ Fetched ${jobs.length} jobs');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching jobs: $e');
    }

    // ✅ جلب التطبيقات - بشكل منفصل
    try {
      final appsResponse = await _apiClient.get(ApiConstants.myApplications);
      final appsData = appsResponse.data;

      if (appsData is List) {
        applications = appsData.cast<Map<String, dynamic>>();
      } else if (appsData is Map && appsData['data'] is List) {
        applications = (appsData['data'] as List).cast<Map<String, dynamic>>();
      }

      if (kDebugMode) debugPrint('✅ Fetched ${applications.length} applications');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching applications: $e');
      // ✅ نكمل حتى لو فشل هذا الطلب
    }

    // ✅ جلب المحادثات - بشكل منفصل
    try {
      final chatResponse = await _chatService.getMyChats('me');
      messages = chatResponse.map((e) => {
        'id': e['id'],
        'text': e['lastMessage'] ?? ''
      }).toList();

      if (kDebugMode) debugPrint('✅ Fetched ${messages.length} messages');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching messages: $e');
      // ✅ نكمل حتى لو فشل هذا الطلب
    }

    // ✅ تحديث الـ Store بالبيانات المتاحة (حتى لو بعضها فارغ)
    try {
      RecruitmentSyncStore.instance.replaceFromRemote(
        jobs: jobs,
        applications: applications,
        messages: messages,
      );

      if (kDebugMode) {
        debugPrint('✅ Store updated: ${jobs.length} jobs, ${applications.length} apps, ${messages.length} messages');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error updating store: $e');
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    stopPolling();
  }

  // Legacy support
  Future<void> verifyEmailOtp({required String email, required String code}) async {}
  Future<void> resendOtp(String email) async {}
}