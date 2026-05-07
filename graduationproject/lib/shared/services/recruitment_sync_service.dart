import 'dart:async';

import '../../data/api/company_api_client.dart';
import '../state/company_store.dart';
import '../state/recruitment_sync_store.dart';
import 'session_manager.dart';

class RecruitmentSyncService {
  RecruitmentSyncService._();

  static final RecruitmentSyncService instance = RecruitmentSyncService._();

  final CompanyApiClient _client = CompanyApiClient();
  Timer? _timer;
  bool get isAuthenticated => _client.hasToken;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String expectedRole,
  }) async {
    final auth = await _client.login(
      email: email.trim(),
      password: password,
      role: expectedRole,
    );

    final user = auth['user'] as Map<String, dynamic>?;
    final role = user?['role']?.toString().toLowerCase().trim();
    final token = auth['token']?.toString().trim();
    final expected = expectedRole.toLowerCase().trim();

    if (token == null || token.isEmpty) {
      throw Exception('Login response missing token');
    }
    if (role == null || role.isEmpty) {
      throw Exception('Login response missing role');
    }
    if (expected == 'company') {
      if (role != 'company') {
        throw Exception('هذا الحساب ليس حساب شركة');
      }
    } else {
      // For user login, block company accounts from signing in
      if (role == 'company') {
        throw Exception('هذا الحساب مخصص للشركات');
      }
    }

    _client.setToken(token);

    // Update store with user info
    if (user != null) {
      final String name = user['name']?.toString() ?? 'User';
      RecruitmentSyncStore.instance.updateCurrentUser(
        name: name,
        email: user['email']?.toString(),
        photoUrl: user['photoUrl']?.toString(),
      );

      if (role == 'company') {
        CompanyStore.instance.setRegistrationData(
          companyId: user['id']?.toString(),
          companyName: name,
          email: user['email']?.toString(),
        );
        final fullProfile = await SessionManager.getCompanyFullProfile();
        await CompanyStore.instance.loadFromSession(fullProfile);
      }
    }

    return user ?? {};
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    final auth = await _client.googleLogin(idToken: idToken);

    final user = auth['user'] as Map<String, dynamic>?;
    final token = auth['token']?.toString().trim();

    if (token == null || token.isEmpty) {
      throw Exception('Google login response missing token');
    }

    _client.setToken(token);

    // Update store with user info
    if (user != null) {
      final String name = user['name']?.toString() ?? 'User';
      RecruitmentSyncStore.instance.updateCurrentUser(
        name: name,
        email: user['email']?.toString(),
        photoUrl: user['photoUrl']?.toString(),
      );

      final role = user['role']?.toString().toLowerCase().trim();
      if (role == 'company') {
        CompanyStore.instance.setRegistrationData(
          companyId: user['id']?.toString(),
          companyName: name,
          email: user['email']?.toString(),
        );
        final fullProfile = await SessionManager.getCompanyFullProfile();
        await CompanyStore.instance.loadFromSession(fullProfile);
      }
    }

    return user ?? {};
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final auth = await _client.register(
      email: email.trim(),
      password: password,
      name: name.trim(),
      role: role.toLowerCase().trim(),
    );

    final user = auth['user'] as Map<String, dynamic>?;
    final token = auth['token']?.toString().trim();

    if (token == null || token.isEmpty) {
      throw Exception('Registration response missing token');
    }

    _client.setToken(token);

    // Update store with user info
    if (user != null) {
      final String name = user['name']?.toString() ?? 'User';
      RecruitmentSyncStore.instance.updateCurrentUser(
        name: name,
        email: user['email']?.toString(),
        photoUrl: user['photoUrl']?.toString(),
      );

      if (role.toLowerCase().trim() == 'company') {
        CompanyStore.instance.setRegistrationData(
          companyId: user['id']?.toString(),
          companyName: name,
          email: user['email']?.toString(),
        );
        final fullProfile = await SessionManager.getCompanyFullProfile();
        await CompanyStore.instance.loadFromSession(fullProfile);
      }
    }

    return user ?? {};
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    _assertAuthenticated();
    final user = await _client.updateProfile(name: name, photoUrl: photoUrl);

    final String currentName = user['name']?.toString() ?? 'User';
    RecruitmentSyncStore.instance.updateCurrentUser(
      name: currentName,
      photoUrl: user['photoUrl']?.toString(),
    );

    if (RecruitmentSyncStore.instance.userRole.toLowerCase() == 'company') {
      CompanyStore.instance.setRegistrationData(
        companyName: currentName,
        customProfileImage: user['photoUrl']?.toString(),
      );
    }

    return user;
  }

  void logout() {
    _client.clearToken();
    stopPolling();
  }

  void _assertAuthenticated() {
    if (!isAuthenticated) {
      throw Exception('Not authenticated. Please login first.');
    }
  }

  Future<void> loginForDemo({required bool companyRole}) async {
    await login(
      email: companyRole ? 'company@jobito.com' : 'user@jobito.com',
      password: '12345678',
      expectedRole: companyRole ? 'company' : 'user',
    );
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

  Future<void> _pullServerState() async {
    final RecruitmentSyncStore store = RecruitmentSyncStore.instance;
    try {
      final jobs = await _client.fetchJobs();
      final applications = await _client.fetchApplications();
      final messages = await _client.fetchMessages();
      store.replaceFromRemote(
        jobs: jobs,
        applications: applications,
        messages: messages,
      );
    } catch (_) {
      // Keep local state if backend is unreachable.
    }
  }

  Future<String> postJob({
    required String title,
    required String location,
    required String salaryRange,
    required String description,
    required List<String> responsibilities,
    required List<String> qualifications,
    required List<String> niceToHaves,
    required List<String> benefits,
    required String category,
    String companyName = 'Jobito Labs',
    String type = 'Full-time',
    List<String> tags = const <String>['General'],
    int requiredCount = 1,
    DateTime? deadline,
  }) async {
    _assertAuthenticated();
    final response = await _client.createJob(
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
      tags: tags,
      category: category,
      requiredCount: requiredCount,
      deadline: deadline,
    );
    final String jobId = response['id']?.toString() ?? '';
    await _pullServerState();
    return jobId;
  }

  Future<void> updateJob({
    required String jobId,
    required String title,
    required String location,
    required String salaryRange,
    required String description,
    required List<String> responsibilities,
    required List<String> qualifications,
    required List<String> niceToHaves,
    required List<String> benefits,
    required String category,
    String companyName = 'Jobito Labs',
    String type = 'Full-time',
    List<String> tags = const <String>['General'],
    int requiredCount = 1,
    DateTime? deadline,
    String? status,
  }) async {
    _assertAuthenticated();
    await _client.updateJob(
      jobId: jobId,
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
      tags: tags,
      category: category,
      requiredCount: requiredCount,
      deadline: deadline,
      status: status,
    );
    await _pullServerState();
  }

  Future<void> applyToJob({
    required String jobId,
    required String userName,
  }) async {
    _assertAuthenticated();
    await _client.createApplication(jobId: jobId, userName: userName);
    await _pullServerState();
  }

  Future<void> updateStatus({
    required String applicationId,
    required String status,
  }) async {
    _assertAuthenticated();
    try {
      await _client.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
      );
      await _pullServerState();
    } catch (_) {
      RecruitmentSyncStore.instance.companyUpdateApplicationStatus(
        applicationId: applicationId,
        nextStatus: status,
      );
    }
  }

  Future<void> sendBroadcast(String text) async {
    _assertAuthenticated();
    try {
      await _client.sendMessage(text);
      await _pullServerState();
    } catch (_) {
      RecruitmentSyncStore.instance.companySendMessage(text);
    }
  }

  Future<void> deleteJob(String jobId) async {
    _assertAuthenticated();
    await _client.deleteJob(jobId);
    // Optimistically remove from both local stores before server refresh
    RecruitmentSyncStore.instance.removeJob(jobId);
    CompanyStore.instance.deleteJob(jobId);
    await _pullServerState();
  }
}
