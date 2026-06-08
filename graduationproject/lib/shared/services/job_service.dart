import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';
import 'rating_service.dart';

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
      if (category != null && category.isNotEmpty)
        queryParams['category'] = category;
      if (city != null && city.isNotEmpty) queryParams['city'] = city;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await ApiClient.get('/jobs', queryParams: queryParams);
      final data = await handleResponse(response, (map) => map);

      final jobsList = data['data'] as List? ?? data['jobs'] as List? ?? [];

      final parsedJobs = jobsList.map((j) {
        final companyMap = j['company'] as Map<String, dynamic>?;
        final userMap = j['user'] as Map<String, dynamic>?;

        final companyName =
            companyMap?['name']?.toString() ??
            userMap?['fullName']?.toString() ??
            'Unknown';
        final logoUrl = ApiClient.resolveImageUrl(
          companyMap?['logoUrl']?.toString() ??
              userMap?['avatarUrl']?.toString(),
        );

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
        final String typeStr = (jobTypeArr != null && jobTypeArr.isNotEmpty)
            ? jobTypeArr.first.toString()
            : 'Full-time';

        String categoryStr = 'General';
        if (j['category'] is String) {
          categoryStr = j['category'].toString();
        } else if (j['category'] is Map) {
          categoryStr = j['category']['name']?.toString() ?? 'General';
        }
        if (categoryStr == 'General' &&
            j['classification'] == 'tradesman_work') {
          categoryStr = 'Tradesman';
        }

        return RecruitmentJob(
          id:
              j['jobId']?.toString() ??
              j['_id']?.toString() ??
              j['id']?.toString() ??
              '',
          title: j['title']?.toString() ?? '',
          companyName: companyName,
          companyLogoUrl: logoUrl,
          location:
              j['address']?.toString() ??
              j['city']?.toString() ??
              j['location']?.toString() ??
              '',
          salaryRange: salaryStr,
          type: typeStr,
          description: j['description']?.toString() ?? '',
          responsibilities:
              (j['responsibilities'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          qualifications:
              (j['qualifications'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          niceToHaves:
              (j['niceToHaves'] as List?)?.map((e) => e.toString()).toList() ??
              [],
          benefits:
              (j['benefits'] as List?)?.map((e) => e.toString()).toList() ?? [],
          category: categoryStr,
          tags:
              ((j['fieldOfWork'] as List?)?.map((e) => e.toString()).toList() ??
                    [])
                ..add(j['classification']?.toString() ?? ''),
          capacity:
              j['slotsAvailable'] as int? ?? j['requiredCount'] as int? ?? 1,
          specialTag:
              j['specialTag']?.toString() ??
              (j['isFeatured'] == true ? 'مميز' : null) ??
              (j['isExceptional'] == true ? 'استثنائي' : null),
          publishedAt: j['createdAt'] != null
              ? DateTime.tryParse(j['createdAt']) ?? DateTime.now()
              : DateTime.now(),
          status: (j['isActive'] == true) ? 'open' : 'closed',
          acceptedCount:
              j['acceptedCount'] as int? ?? j['applicantsCount'] as int? ?? 0,
        );
      }).toList();

      RecruitmentSyncStore.instance.replaceFromRemote(
        jobs: parsedJobs,
        applications: null,
        messages: null,
      );

      return parsedJobs;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createJob(Map<String, dynamic> body) async {
    try {
      final response = await ApiClient.post(
        '/jobs',
        requiresAuth: true,
        body: body,
      );
      final data = await handleResponse(response, (map) => map);

      // If the backend returns the job object in data['job'] or just the data map
      final j = data['job'] ?? data;
      return j['jobId']?.toString() ??
          j['_id']?.toString() ??
          j['id']?.toString() ??
          '';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> body) async {
    try {
      final response = await ApiClient.patch(
        '/jobs/$jobId',
        requiresAuth: true,
        body: body,
      );
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      final response = await ApiClient.delete(
        '/jobs/$jobId',
        requiresAuth: true,
      );
      await handleResponse(response, (map) => map);
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

      final companyName =
          companyMap?['name']?.toString() ??
          userMap?['fullName']?.toString() ??
          'Unknown';
      final logoUrl = ApiClient.resolveImageUrl(
        companyMap?['logoUrl']?.toString() ?? userMap?['avatarUrl']?.toString(),
      );

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
      final String typeStr = (jobTypeArr != null && jobTypeArr.isNotEmpty)
          ? jobTypeArr.first.toString()
          : 'Full-time';

      final categoryMap = j['category'] as Map<String, dynamic>?;
      final categoryStr =
          categoryMap?['name']?.toString() ??
          (j['classification'] == 'tradesman_work' ? 'Tradesman' : 'General');

      return RecruitmentJob(
        id:
            j['jobId']?.toString() ??
            j['_id']?.toString() ??
            j['id']?.toString() ??
            '',
        title: j['title']?.toString() ?? '',
        companyName: companyName,
        companyLogoUrl: logoUrl,
        location:
            j['address']?.toString() ??
            j['city']?.toString() ??
            j['location']?.toString() ??
            '',
        salaryRange: salaryStr,
        type: typeStr,
        description: j['description']?.toString() ?? '',
        responsibilities:
            (j['responsibilities'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        qualifications:
            (j['qualifications'] as List?)?.map((e) => e.toString()).toList() ??
            [],
        niceToHaves:
            (j['niceToHaves'] as List?)?.map((e) => e.toString()).toList() ??
            [],
        benefits:
            (j['benefits'] as List?)?.map((e) => e.toString()).toList() ?? [],
        category: categoryStr,
        tags:
            (j['fieldOfWork'] as List?)?.map((e) => e.toString()).toList() ??
            [],
        capacity:
            j['slotsAvailable'] as int? ?? j['requiredCount'] as int? ?? 1,
        publishedAt: j['createdAt'] != null
            ? DateTime.tryParse(j['createdAt']) ?? DateTime.now()
            : DateTime.now(),
        status: (j['isActive'] == true) ? 'open' : 'closed',
        acceptedCount:
            j['acceptedCount'] as int? ?? j['applicantsCount'] as int? ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getNearbyJobs({
    required double lat,
    required double lng,
    int radius = 10,
  }) async {
    try {
      final response = await ApiClient.get(
        '/jobs/nearby',
        queryParams: {
          'lat': lat.toString(),
          'lng': lng.toString(),
          'radius': radius.toString(),
        },
      );
      final data = await handleResponse(response, (map) => map);
      return data['data'] ?? data['jobs'] ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> postJob(Map<String, dynamic> jobData) async {
    try {
      final response = await ApiClient.post(
        '/jobs',
        requiresAuth: true,
        body: jobData,
      );
      return response.statusCode == 201 || response.statusCode == 200;
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
    await RatingService.instance.createRating(
      ratingValue: ratingValue,
      comment: comment,
      companyId: companyId,
      jobId: jobId,
      targetUserId: targetUserId,
      raterType: raterType,
    );
  }
}
