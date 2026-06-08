import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../data/api/company_api_client.dart';
import '../../data/api/api_client.dart';
import '../state/company_store.dart';
import '../state/recruitment_sync_store.dart';
import 'session_manager.dart';
import 'company_service.dart';

class RecruitmentSyncService {
  RecruitmentSyncService._();

  static final RecruitmentSyncService instance = RecruitmentSyncService._();

  final CompanyApiClient _client = CompanyApiClient();
  Timer? _timer;
  bool get isAuthenticated => _client.hasToken;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? expectedRole,
  }) async {
    try {
      final auth = await _client.login(
        email: email.trim(),
        password: password,
        role: expectedRole,
      );

      final user = auth['user'] as Map<String, dynamic>?;
      final role = user?['role']?.toString().toLowerCase().trim();
      final token = auth['token']?.toString().trim();

      if (token == null || token.isEmpty) {
        throw Exception('Login response missing token');
      }
      
      _client.setToken(token);
      await ApiClient.saveToken(token);

      if (user != null) {
        final String name = user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
        final email = user['email']?.toString() ?? '';
        final photoUrl = ApiClient.resolveImageUrl(user['avatar']?.toString() ?? user['photoUrl']?.toString());
        final bioStr = user['bio']?.toString();
        final locationStr = user['location']?.toString();
        final phoneStr = user['phone']?.toString();
        final roleStr = user['role']?.toString();
        final titleStr = user['classification']?.toString() ?? user['title']?.toString() ?? '';
        
        List<String>? tradesmanServices;
        if (user['services'] is List) {
          tradesmanServices = (user['services'] as List).map((e) => e.toString()).toList();
        }
        
        RecruitmentSyncStore.instance.updateUserProfile(
          fullName: name,
          title: titleStr,
          email: email,
          phone: phoneStr,
          location: locationStr,
          about: bioStr,
          role: roleStr,
          tradesmanServices: tradesmanServices,
          profileImage: photoUrl,
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
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      final auth = await _client.googleLogin(idToken: idToken);
      final token = auth['token']?.toString().trim();
      if (token != null) _client.setToken(token);
      return auth;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final auth = await _client.register(
        email: email.trim(),
        password: password,
        name: name.trim(),
        role: role.toLowerCase().trim(),
      );

      final token = auth['token']?.toString().trim();
      if (token != null) _client.setToken(token);

      return auth;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    _assertAuthenticated();
    final response = await _client.updateProfile(name: name, photoUrl: photoUrl);
    
    // Update local store state so UI updates immediately
    RecruitmentSyncStore.instance.updateCurrentUser(
      name: name,
      photoUrl: photoUrl,
    );
    
    return response;
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
    } catch (_) {}
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
    _assertAuthenticated();
    try {
      await _client.updateJob(jobId, {
        'title': title,
        'companyName': companyName,
        'location': location,
        'salaryRange': salaryRange,
        'type': type,
        'description': description,
        'responsibilities': responsibilities,
        'qualifications': qualifications,
        'niceToHaves': niceToHaves,
        'benefits': benefits,
        'category': category,
        'tags': tags,
        'requiredCount': requiredCount,
        if (deadline != null) 'deadline': deadline.toUtc().toIso8601String(),
        if (status != null) 'status': status,
      });
      await _pullServerState();
    } catch (_) {}
  }

  Future<void> deleteJob(String jobId) async {
    _assertAuthenticated();
    try {
      await _client.deleteJob(jobId);
      await _pullServerState();
    } catch (_) {}
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
    _assertAuthenticated();
    try {
      final response = await _client.createJob({
        'title': title,
        'companyName': companyName,
        'location': location,
        'salaryRange': salaryRange,
        'type': type,
        'description': description,
        'responsibilities': responsibilities,
        'qualifications': qualifications,
        'niceToHaves': niceToHaves,
        'benefits': benefits,
        'tags': tags,
        'category': category,
        'requiredCount': requiredCount,
        if (deadline != null) 'deadline': deadline.toIso8601String(),
      });
      await _pullServerState();
      return response['id']?.toString() ?? '';
    } catch (e) {
      throw Exception('فشل نشر الوظيفة');
    }
  }

  Future<void> applyToJob({
    required String jobId,
    required String userName,
  }) async {
    _assertAuthenticated();
    try {
      await _client.createApplication(jobId: jobId, userName: userName);
      await _pullServerState();
    } catch (_) {}
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
    if (!isAuthenticated) return;
    
    List<dynamic>? jobs;
    List<dynamic>? applications;
    List<dynamic>? messages;
    List<dynamic>? companiesList;

    try {
      jobs = await _client.fetchJobs();
      applications = await _client.fetchApplications();
      messages = await _client.fetchMessages();
    } catch (_) {}

    try {
      companiesList = await CompanyService.instance.getCompanies();
    } catch (_) {}

    RecruitmentSyncStore.instance.replaceFromRemote(
      jobs: jobs,
      applications: applications,
      messages: messages,
      companies: companiesList,
    );
  }

  String _handleDioError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map;
      return data['message']?.toString() ?? data['error']?.toString() ?? 'حدث خطأ في الطلب';
    }
    return 'حدث خطأ غير متوقع';
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

  // Legacy support
  Future<void> verifyEmailOtp({required String email, required String code}) async {}
  Future<void> resendOtp(String email) async {}
}
