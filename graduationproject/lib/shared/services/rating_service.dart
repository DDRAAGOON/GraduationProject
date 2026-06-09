import 'dart:convert';

import '../../data/api/api_client.dart';
import '../utils/rating_utils.dart';

class RatingService {
  RatingService._();
  static final RatingService instance = RatingService._();

  Future<void> createRating({
    required num ratingValue,
    String? comment,
    dynamic companyId,
    String? targetUserId,
    dynamic jobId,
    String? raterType,
  }) async {
    final body = <String, dynamic>{'ratingValue': ratingValue};
    if (comment != null && comment.isNotEmpty) body['comment'] = comment;
    if (companyId != null) body['companyId'] = int.tryParse(companyId.toString()) ?? companyId;
    if (targetUserId != null && targetUserId.isNotEmpty) {
      body['targetUserId'] = targetUserId;
    }
    if (jobId != null) body['jobId'] = int.tryParse(jobId.toString()) ?? jobId;
    if (raterType != null && raterType.isNotEmpty) body['raterType'] = raterType;

    final response = await ApiClient.post(
      '/ratings',
      requiresAuth: true,
      body: body,
    );
    await handleResponse(response, (map) => map);
  }

  Future<List<Map<String, dynamic>>> getCompanyRatings(dynamic companyId) async {
    return _fetchList('/ratings/company/$companyId');
  }

  Future<List<Map<String, dynamic>>> getUserRatings(String userId) async {
    return _fetchList('/ratings/user/$userId');
  }

  Future<List<Map<String, dynamic>>> getJobRatings(dynamic jobId) async {
    return _fetchList('/ratings/job/$jobId');
  }

  Future<List<Map<String, dynamic>>> getCompanyGivenRatings(
    dynamic companyId,
  ) async {
    return _fetchList('/ratings/company/$companyId/given', requiresAuth: true);
  }

  Future<List<Map<String, dynamic>>> getUserGivenRatings(String userId) async {
    return _fetchList('/ratings/user/$userId/given', requiresAuth: true);
  }

  Future<List<Map<String, dynamic>>> _fetchList(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final response = await ApiClient.get(
        endpoint,
        requiresAuth: requiresAuth,
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return [];
      }
      if (response.body.isEmpty) return [];
      final decoded = jsonDecode(response.body);
      return RatingUtils.parseList(decoded);
    } catch (_) {
      return [];
    }
  }
}
