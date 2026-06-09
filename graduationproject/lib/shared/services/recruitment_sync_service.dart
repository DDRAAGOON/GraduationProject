import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_error_handler.dart';
import '../../core/network/secure_storage.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/company_service.dart';
import '../../data/services/job_service.dart';
import '../../data/services/application_service.dart';
import '../../data/services/chat_service.dart';
import '../../data/models/auth/auth_models.dart';
import '../../data/models/job/job_models.dart';
import '../../data/models/application/application_models.dart';
import '../../data/models/company/company_models.dart';
import '../state/company_store.dart';
import '../state/recruitment_sync_store.dart';
import 'session_manager.dart';

class RecruitmentSyncService {
  RecruitmentSyncService._() {
    _apiClient = ApiClient();
    _authService = AuthService(_apiClient);
    _companyService = CompanyService(_apiClient);
    _jobService = JobService(_apiClient);
    _applicationService = ApplicationService(_apiClient);
    _chatService = ChatService(_apiClient);
  }

  static final RecruitmentSyncService instance = RecruitmentSyncService._();

  late final ApiClient _apiClient;
  late final AuthService _authService;
  late final CompanyService _companyService;
  late final JobService _jobService;
  late final ApplicationService _applicationService;
  late final ChatService _chatService;

  Timer? _timer;
  String? _currentUserRole;

  // ✅ تتبع آخر وقت تم فيه الـ pull
  DateTime? _lastPullTime;

  // ✅ تتبع عدد الـ jobs الخاصة بالشركة
  int _companyJobsCount = 0;

  Future<bool> get isAuthenticated async {
    final token = await SecureStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// ✅ استخراج الدور من JWT token
  Future<String?> _extractRoleFromToken() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null || token.isEmpty) return null;

      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      return json['role']?.toString();
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Could not extract role: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      await _authService.googleLogin(idToken);
      final user = await _authService.getMe();
      _currentUserRole = user.role;
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
      _currentUserRole = authResponse.user?.role;
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
      _currentUserRole = user.role;

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
        RegisterRequest(
          email: email,
          password: password,
          fullName: name,
          role: role,
          phone: phone,
        ),
      );
      _currentUserRole = role;
      return authResponse.user;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<User> updateProfile({String? name, String? photoUrl}) async {
    try {
      final user = await _authService.updateMe(
        {'fullName': name, 'photoUrl': photoUrl}
          ..removeWhere((_, v) => v == null),
      );

      RecruitmentSyncStore.instance.updateCurrentUser(
        name: user.fullName ?? '',
        photoUrl: user.photoUrl,
      );

      return user;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Sends a full profile payload to PUT /api/users/me and returns the raw
  /// response map so the caller can inspect [requiresLogout] and [access_token].
  Future<Map<String, dynamic>> completeUserProfile(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _apiClient.put(ApiConstants.userMe, data: payload);
      // response.data may contain requiresLogout and access_token
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {};
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Fetches the authenticated company's full profile
  Future<CompanyProfile> getCompanyProfile() async {
    return _companyService.getCompanyProfile();
  }

  Future<CompanyStatistics> getCompanyStatistics(String companyId) async {
    return _companyService.getCompanyStatistics(companyId);
  }

  /// --------------------------------------------------------------------------
  /// Updates the company profile via PATCH /api/companies/my/profile
  /// and synchronises the local [CompanyStore] and [SessionManager] on success.
  Future<void> updateCompanyProfile({
    required String name,
    String? employee,
    String? industry,
    String? website,
    String? aboutEn,
    String? aboutAr,
    List<String>? locations,
    List<String>? techStack,
    List<String>? benefits,
    String? category,
    int? foundedDay,
    int? foundedMonth,
    int? foundedYear,
    String? commercialRegister,
    String? nationalNumber,
    String? photoUrl,
    Map<String, String>? socialLinks,
  }) async {
    try {
      final store = CompanyStore.instance;

      // Build payload – only include non-null fields
      final Map<String, dynamic> payload = {
        'name': name,
        if (employee != null && employee.isNotEmpty) 'employees': employee,
        if (industry != null && industry.isNotEmpty) 'industry': industry,
        if (website != null && website.isNotEmpty) 'website': website,
        if (aboutEn != null && aboutEn.isNotEmpty) 'description': aboutEn,

        // تعديلات لتطابق الباك-إند تماماً:
        if (photoUrl != null && photoUrl.isNotEmpty)
          'logo': photoUrl, // Backend reads body.logo
        if (benefits != null && benefits.isNotEmpty) 'benefits': benefits,
        if (techStack != null && techStack.isNotEmpty) 'techStack': techStack,
        if (locations != null && locations.isNotEmpty)
          'locationTags': locations, // Backend reads body.locationTags
        if (category != null && category.isNotEmpty)
          'classification': category, // Backend reads body.classification
        if (socialLinks != null && socialLinks.isNotEmpty)
          'socialLinks': socialLinks,
      };

      // الباك-إند يحتاج التاريخ في حقل واحد 'foundedDate' كـ String
      if (foundedYear != null &&
          foundedYear > 0 &&
          foundedMonth != null &&
          foundedMonth > 0 &&
          foundedDay != null &&
          foundedDay > 0) {
        final m = foundedMonth.toString().padLeft(2, '0');
        final d = foundedDay.toString().padLeft(2, '0');
        payload['foundedDate'] = '$foundedYear-$m-$d';
      }

      await _companyService.updateMyCompanyProfile(payload);

      if (kDebugMode) debugPrint('✅ Company profile updated via API');

      // Sync local store
      store.updateProfile(
        name: name,
        website: website ?? store.website,
        employee: employee ?? store.employee,
        industry: industry ?? store.industry,
        aboutEn: aboutEn ?? store.companyAboutEn,
        aboutAr: aboutAr ?? store.companyAboutAr,
        locations: locations ?? List.from(store.locations),
        techStack: techStack ?? List.from(store.techStack),
        foundedDay: foundedDay ?? store.foundedDay,
        foundedMonth: foundedMonth ?? store.foundedMonth,
        foundedYear: foundedYear ?? store.foundedYear,
        category: category ?? store.category,
        benefits: benefits ?? List.from(store.benefits),
        commercialRegister: commercialRegister ?? store.commercialRegister,
        nationalNumber: nationalNumber ?? store.nationalNumber,
      );

      // Persist locally
      await SessionManager.saveCompanyFullProfile(
        employee: employee ?? store.employee,
        industry: industry ?? store.industry,
        aboutEn: aboutEn ?? store.companyAboutEn,
        aboutAr: aboutAr ?? store.companyAboutAr,
        locations: locations ?? List.from(store.locations),
        techStack: techStack ?? List.from(store.techStack),
        foundedDay: foundedDay ?? store.foundedDay,
        foundedMonth: foundedMonth ?? store.foundedMonth,
        foundedYear: foundedYear ?? store.foundedYear,
        category: category ?? store.category,
        benefits: benefits ?? List.from(store.benefits),
        commercialRegister: commercialRegister ?? store.commercialRegister,
        nationalNumber: nationalNumber ?? store.nationalNumber,
      );
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

      // ✅ تحديث محلي فوري قبل الـ pull
      RecruitmentSyncStore.instance.companyUpdateApplicationStatus(
        applicationId: applicationId,
        nextStatus: status,
      );

      // ✅ إعادة جلب البيانات بعد ثانية
      await Future.delayed(const Duration(seconds: 1));
      await _pullServerState();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error updating status: $e');
      rethrow;
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

    if (_currentUserRole == null) {
      _currentUserRole = await _extractRoleFromToken();
    }

    await _pullServerState();
    _timer?.cancel();

    // ✅ زيادة الـ polling interval إلى 2 دقيقة لتقليل الضغط
    _timer = Timer.periodic(const Duration(minutes: 2), (_) async {
      await _pullServerState();
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  /// ✅ الدالة المحسّنة مع logging واضح
  Future<void> _pullServerState() async {
    if (!await isAuthenticated) {
      if (kDebugMode) debugPrint('⚠️ Not authenticated, skipping pull');
      return;
    }

    if (_currentUserRole == null) {
      _currentUserRole = await _extractRoleFromToken();
    }

    // ✅ تسجيل وقت الـ pull
    _lastPullTime = DateTime.now();
    if (kDebugMode)
      debugPrint('🔄 Pulling server state (role: $_currentUserRole)...');

    List<Map<String, dynamic>> jobs = [];
    List<Map<String, dynamic>> applications = [];
    List<Map<String, dynamic>> messages = [];

    // ✅ 1. جلب كل الوظائف
    try {
      final jobsResponse = await _apiClient.get(ApiConstants.jobs);
      final jobsData = jobsResponse.data;

      if (jobsData is List) {
        jobs = jobsData.cast<Map<String, dynamic>>();
      } else if (jobsData is Map && jobsData['data'] is List) {
        jobs = (jobsData['data'] as List).cast<Map<String, dynamic>>();
      }

      if (kDebugMode) debugPrint('✅ Fetched ${jobs.length} jobs (all jobs)');

      // ✅ logging لكل وظيفة
      if (kDebugMode && jobs.isNotEmpty) {
        for (var i = 0; i < jobs.length && i < 3; i++) {
          final job = jobs[i];
          final companyData = job['company'];
          final userData = job['user'];
          final companyName = companyData is Map
              ? companyData['name']?.toString() ?? 'N/A'
              : userData is Map
              ? userData['fullName']?.toString() ?? 'N/A'
              : 'N/A';
          debugPrint(
            '   [$i] Job ${job['jobId']}: ${job['title']} by $companyName',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching jobs: $e');
    }

    // ✅ 2. جلب التطبيقات - حسب الدور
    if (_currentUserRole == 'company') {
      if (kDebugMode)
        debugPrint('ℹ️ Skipping /applications/my for company role');

      final companyName = CompanyStore.instance.companyName;
      _companyJobsCount = 0;

      if (companyName.isNotEmpty) {
        // ✅ فلترة الوظائف بتاعة الشركة
        final companyJobs = jobs.where((job) {
          final companyData = job['company'];
          if (companyData is Map) {
            final name = companyData['name']?.toString() ?? '';
            final match =
                name.trim().toLowerCase() == companyName.trim().toLowerCase();
            if (match) _companyJobsCount++;
            return match;
          }
          return false;
        }).toList();

        if (kDebugMode) {
          debugPrint(
            '🏢 Found $_companyJobsCount jobs for company: $companyName',
          );
        }

        // ✅ جلب المتقدمين لكل وظيفة بتاعة الشركة
        for (final job in companyJobs) {
          final jobId = job['jobId']?.toString() ?? job['id']?.toString();
          if (jobId == null) continue;

          try {
            final appsResponse = await _apiClient.get(
              '${ApiConstants.applications}/job/$jobId',
            );
            final appsData = appsResponse.data;

            int addedCount = 0;
            if (appsData is List) {
              for (final app in appsData) {
                if (app is Map) {
                  final appMap = Map<String, dynamic>.from(app);
                  appMap['jobId'] = jobId;
                  applications.add(appMap);
                  addedCount++;
                }
              }
            } else if (appsData is Map && appsData['data'] is List) {
              for (final app in appsData['data'] as List) {
                if (app is Map) {
                  final appMap = Map<String, dynamic>.from(app);
                  appMap['jobId'] = jobId;
                  applications.add(appMap);
                  addedCount++;
                }
              }
            }

            if (kDebugMode) {
              debugPrint('✅ Job $jobId: $addedCount applicants');
            }
          } catch (e) {
            if (kDebugMode)
              debugPrint('⚠️ Could not fetch apps for job $jobId: $e');
          }
        }
      }

      if (kDebugMode)
        debugPrint('✅ Total applications: ${applications.length}');
    } else {
      try {
        final appsResponse = await _apiClient.get(ApiConstants.myApplications);
        final appsData = appsResponse.data;

        if (appsData is List) {
          applications = appsData.cast<Map<String, dynamic>>();
        } else if (appsData is Map && appsData['data'] is List) {
          applications = (appsData['data'] as List)
              .cast<Map<String, dynamic>>();
        }

        if (kDebugMode)
          debugPrint('✅ Fetched ${applications.length} applications');
      } catch (e) {
        if (kDebugMode) debugPrint('⚠️ Skipping applications: $e');
      }
    }

    // ✅ 3. جلب المحادثات
    try {
      final chatResponse = await _chatService.getMyChats('me');

      if (chatResponse is List && chatResponse.isNotEmpty) {
        messages = chatResponse.whereType<Map>().map((e) {
          return {
            'id': e['id']?.toString() ?? '',
            'text': e['lastMessage']?.toString() ?? e['text']?.toString() ?? '',
          };
        }).toList();
      }

      if (kDebugMode) debugPrint('✅ Fetched ${messages.length} messages');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching messages: $e');
    }

    // ✅ 4. تحديث الـ Store
    try {
      RecruitmentSyncStore.instance.replaceFromRemote(
        jobs: jobs,
        applications: applications,
        messages: messages,
      );

      if (kDebugMode) {
        debugPrint(
          '✅ Store updated: ${jobs.length} jobs, ${applications.length} apps, ${messages.length} messages',
        );
        debugPrint('🏢 Company: ${CompanyStore.instance.companyName}');
        debugPrint('📊 Company jobs count: $_companyJobsCount');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error updating store: $e');
    }
  }

  /// ✅ الحصول على معلومات الـ sync الحالية
  Map<String, dynamic> getSyncInfo() {
    return {
      'lastPullTime': _lastPullTime?.toIso8601String(),
      'currentUserRole': _currentUserRole,
      'companyJobsCount': _companyJobsCount,
      'isPolling': _timer != null,
    };
  }

  Future<void> logout() async {
    await _authService.logout();
    stopPolling();
    _currentUserRole = null;
    _lastPullTime = null;
    _companyJobsCount = 0;
  }

  // Legacy support
  Future<void> verifyEmailOtp({
    required String email,
    required String code,
  }) async {}
  Future<void> resendOtp(String email) async {}
}
