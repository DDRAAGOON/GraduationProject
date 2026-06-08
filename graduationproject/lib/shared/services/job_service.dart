import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';
import '../models/job.dart';

class JobService {
  JobService._();
  static final JobService instance = JobService._();

  Future<List<RecruitmentJob>> getJobs({
    String? category,
    String? city,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (city != null && city.isNotEmpty) queryParams['city'] = city;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await ApiClient.get('/jobs', queryParams: queryParams);
      final data = await handleResponse(response, (map) => map);
      
      final jobsList = data['data'] as List? ?? data['jobs'] as List? ?? [];
      
      final parsedJobs = jobsList.map((j) {
        final companyMap = j['company'] as Map<String, dynamic>?;
        final userMap = j['user'] as Map<String, dynamic>?;
        
        final companyName = companyMap?['name']?.toString() ?? userMap?['fullName']?.toString() ?? 'Unknown';
        final logoUrl = ApiClient.resolveImageUrl(companyMap?['logoUrl']?.toString() ?? userMap?['avatarUrl']?.toString());
        
        final minS = j['salaryMin']?.toString();
        final maxS = j['salaryMax']?.toString();
        final baseS = j['salary']?.toString();
        String salaryStr = '';
        if (minS != null && maxS != null) {
          salaryStr = '$minS - $maxS';
        } else if (baseS != null) {
          salaryStr = baseS;
        } else {
          salaryStr = 'Negotiable';
        }

        final jobTypeArr = j['jobType'] as List?;
        final String typeStr = (jobTypeArr != null && jobTypeArr.isNotEmpty) ? jobTypeArr.first.toString() : 'Full-time';

        final categoryMap = j['category'] as Map<String, dynamic>?;
        final categoryStr = categoryMap?['name']?.toString() ?? (j['classification'] == 'tradesman_work' ? 'Tradesman' : 'General');

        return RecruitmentJob(
          id: j['jobId']?.toString() ?? j['_id']?.toString() ?? j['id']?.toString() ?? '',
          title: j['title']?.toString() ?? '',
          companyName: companyName,
          companyLogoUrl: logoUrl,
          location: j['address']?.toString() ?? j['city']?.toString() ?? j['location']?.toString() ?? '',
          salaryRange: salaryStr,
          type: typeStr,
          description: j['description']?.toString() ?? '',
          responsibilities: (j['responsibilities'] as List?)?.map((e) => e.toString()).toList() ?? [],
          qualifications: (j['qualifications'] as List?)?.map((e) => e.toString()).toList() ?? [],
          niceToHaves: (j['niceToHaves'] as List?)?.map((e) => e.toString()).toList() ?? [],
          benefits: (j['benefits'] as List?)?.map((e) => e.toString()).toList() ?? [],
          category: categoryStr,
          tags: (j['fieldOfWork'] as List?)?.map((e) => e.toString()).toList() ?? [],
          capacity: j['slotsAvailable'] as int? ?? j['requiredCount'] as int? ?? 1,
          publishedAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) ?? DateTime.now() : DateTime.now(),
          status: (j['isActive'] == true) ? 'open' : 'closed',
          acceptedCount: j['acceptedCount'] as int? ?? j['applicantsCount'] as int? ?? 0,
        );
      }).toList();

      RecruitmentSyncStore.instance.replaceFromRemote(jobs: parsedJobs, applications: null, messages: null);

      return parsedJobs;
    } catch (e) {
      rethrow;
    }
  }

  Future<RecruitmentJob> getJobDetails(String jobId) async {
    try {
      final response = await ApiClient.get('/jobs/$jobId');
      final data = await handleResponse(response, (map) => map);
      final j = data['job'] ?? data;
      final companyMap = j['company'] as Map<String, dynamic>?;
      final userMap = j['user'] as Map<String, dynamic>?;
      
      final companyName = companyMap?['name']?.toString() ?? userMap?['fullName']?.toString() ?? 'Unknown';
      final logoUrl = ApiClient.resolveImageUrl(companyMap?['logoUrl']?.toString() ?? userMap?['avatarUrl']?.toString());
      
      final minS = j['salaryMin']?.toString();
      final maxS = j['salaryMax']?.toString();
      final baseS = j['salary']?.toString();
      String salaryStr = '';
      if (minS != null && maxS != null) {
        salaryStr = '$minS - $maxS';
      } else if (baseS != null) {
        salaryStr = baseS;
      } else {
        salaryStr = 'Negotiable';
      }

      final jobTypeArr = j['jobType'] as List?;
      final String typeStr = (jobTypeArr != null && jobTypeArr.isNotEmpty) ? jobTypeArr.first.toString() : 'Full-time';

      final categoryMap = j['category'] as Map<String, dynamic>?;
      final categoryStr = categoryMap?['name']?.toString() ?? (j['classification'] == 'tradesman_work' ? 'Tradesman' : 'General');

      return RecruitmentJob(
        id: j['jobId']?.toString() ?? j['_id']?.toString() ?? j['id']?.toString() ?? '',
        title: j['title']?.toString() ?? '',
        companyName: companyName,
        companyLogoUrl: logoUrl,
        location: j['address']?.toString() ?? j['city']?.toString() ?? j['location']?.toString() ?? '',
        salaryRange: salaryStr,
        type: typeStr,
        description: j['description']?.toString() ?? '',
        responsibilities: (j['responsibilities'] as List?)?.map((e) => e.toString()).toList() ?? [],
        qualifications: (j['qualifications'] as List?)?.map((e) => e.toString()).toList() ?? [],
        niceToHaves: (j['niceToHaves'] as List?)?.map((e) => e.toString()).toList() ?? [],
        benefits: (j['benefits'] as List?)?.map((e) => e.toString()).toList() ?? [],
        category: categoryStr,
        tags: (j['fieldOfWork'] as List?)?.map((e) => e.toString()).toList() ?? [],
        capacity: j['slotsAvailable'] as int? ?? j['requiredCount'] as int? ?? 1,
        publishedAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) ?? DateTime.now() : DateTime.now(),
        status: (j['isActive'] == true) ? 'open' : 'closed',
        acceptedCount: j['acceptedCount'] as int? ?? j['applicantsCount'] as int? ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitRating({
    required int ratingValue,
    String? comment,
    int? companyId,
    int? jobId,
    String? targetUserId,
    String? raterType,
  }) async {
    try {
      final body = <String, dynamic>{
        'ratingValue': ratingValue,
      };
      if (comment != null && comment.isNotEmpty) body['comment'] = comment;
      if (companyId != null) body['companyId'] = companyId;
      if (jobId != null) body['jobId'] = jobId;
      if (targetUserId != null) body['targetUserId'] = targetUserId;
      if (raterType != null) body['raterType'] = raterType;

      final response = await ApiClient.post('/ratings', requiresAuth: true, body: body);
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
