import 'dart:async';

import '../../data/api/company_api_client.dart';
import '../state/recruitment_sync_store.dart';

class RecruitmentSyncService {
  RecruitmentSyncService._();

  static final RecruitmentSyncService instance = RecruitmentSyncService._();

  final CompanyApiClient _client = CompanyApiClient();
  Timer? _timer;

  Future<void> loginForDemo({required bool companyRole}) async {
    final auth = await _client.login(
      email: companyRole ? 'company@jobito.com' : 'user@jobito.com',
      password: '12345678',
    );
    final token = auth['token']?.toString();
    if (token != null && token.isNotEmpty) {
      _client.setToken(token);
    }
  }

  Future<void> startPolling() async {
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

  Future<void> postJob({
    required String title,
    required String location,
    required String salaryRange,
    String companyName = 'Jobito Labs',
    String type = 'Full-time',
    List<String> tags = const <String>['General'],
  }) async {
    try {
      final auth = await _client.login(
        email: 'company@jobito.com',
        password: '12345678',
      );
      _client.setToken(auth['token']?.toString() ?? '');
      await _client.createJob(
        title: title,
        companyName: companyName,
        location: location,
        salaryRange: salaryRange,
        type: type,
        tags: tags,
      );
      await _pullServerState();
    } catch (_) {
      RecruitmentSyncStore.instance.companyPostJob(
        RecruitmentJob(
          id: 'job_${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          companyName: companyName,
          location: location,
          salaryRange: salaryRange,
          type: type,
          tags: tags,
          publishedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> applyToJob({
    required String jobId,
    required String userName,
  }) async {
    try {
      final auth = await _client.login(
        email: 'user@jobito.com',
        password: '12345678',
      );
      _client.setToken(auth['token']?.toString() ?? '');
      await _client.createApplication(jobId: jobId, userName: userName);
      await _pullServerState();
    } catch (_) {
      RecruitmentSyncStore.instance.userApplyToJob(jobId: jobId, userName: userName);
    }
  }

  Future<void> updateStatus({
    required String applicationId,
    required String status,
  }) async {
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
    try {
      await _client.sendMessage(text);
      await _pullServerState();
    } catch (_) {
      RecruitmentSyncStore.instance.companySendMessage(text);
    }
  }
}
