import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';
import '../models/applicant.dart';

class ApplicationService {
  ApplicationService._();
  static final ApplicationService instance = ApplicationService._();

  Future<void> applyToJob({
    required String jobId,
    String? coverLetter,
    String? portfolioUrl,
    String? address,
    String? resumeUrl,
  }) async {
    try {
      final body = <String, dynamic>{
        'jobId': jobId,
      };
      if (coverLetter != null && coverLetter.isNotEmpty) body['coverLetter'] = coverLetter;
      if (portfolioUrl != null && portfolioUrl.isNotEmpty) body['portfolioUrl'] = portfolioUrl;
      if (address != null && address.isNotEmpty) body['address'] = address;
      if (resumeUrl != null && resumeUrl.isNotEmpty) body['resumeUrl'] = resumeUrl;

      // The user mentioned it might be /applications/apply or /applications.
      // Usually NestJS controllers with @Post('apply') will be /applications/apply
      // I will use /applications/apply as suggested by the backend snippet.
      final response = await ApiClient.post('/applications/apply', requiresAuth: true, body: body);
      await handleResponse(response, (map) => map);
      await getMyApplications(); // refresh applications list
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RecruitmentApplication>> getMyApplications() async {
    try {
      final response = await ApiClient.get('/applications/my', requiresAuth: true);
      final data = await handleResponse(response, (map) => map);
      
      final list = data['applications'] as List? ?? [];
      
      final parsed = list.map((a) {
        return RecruitmentApplication(
          id: a['_id']?.toString() ?? a['id']?.toString() ?? '',
          jobId: a['jobId']?.toString() ?? '',
          jobTitle: a['jobTitle']?.toString() ?? 'Job',
          companyName: a['companyName']?.toString() ?? 'Company',
          userName: RecruitmentSyncStore.instance.currentUserName,
          status: a['status']?.toString() ?? 'pending',
          updatedAt: a['updatedAt'] != null ? DateTime.tryParse(a['updatedAt']) ?? DateTime.now() : DateTime.now(),
        );
      }).toList();

      RecruitmentSyncStore.instance.replaceFromRemote(jobs: null, applications: parsed, messages: null);
      return parsed;
    } catch (e) {
      rethrow;
    }
  }
}
