import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_error_handler.dart';
import '../../shared/models/rating.dart';

class RatingService {
  final ApiClient _apiClient;

  RatingService(this._apiClient);

  /// ✅ إضافة تقييم جديد
  Future<Rating?> createRating({
    required double ratingValue,
    String? comment,
    String? companyId,
    String? targetUserId,
    String? jobId,
    String raterType = 'user',
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('🌟 Creating rating: $ratingValue for company: $companyId');
      }

      final data = <String, dynamic>{
        'ratingValue': ratingValue,
        'raterType': raterType,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
        if (companyId != null) 'companyId': companyId,
        if (targetUserId != null) 'targetUserId': targetUserId,
        if (jobId != null) 'jobId': jobId,
      };

      final response = await _apiClient.post(ApiConstants.ratings, data: data);

      final raw = response.data;
      final ratingData = (raw is Map && raw['data'] != null)
          ? raw['data']
          : raw;
      final rating = Rating.fromMap(ratingData as Map<String, dynamic>);

      if (kDebugMode) debugPrint('✅ Rating created: ${rating.ratingId}');
      return rating;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error creating rating: $e');
      throw ErrorHandler.handle(e);
    }
  }

  /// ✅ جلب تقييمات شركة + متوسط التقييم
  Future<({List<Rating> ratings, double average, int total})>
  getCompanyRatingsWithStats(String companyId) async {
    try {
      if (kDebugMode) debugPrint('🌟 Fetching ratings for company: $companyId');

      final response = await _apiClient.get(
        ApiConstants.companyRatings(companyId),
      );
      final data = response.data;

      List<dynamic> ratingsList = [];
      double average = 0.0;
      int total = 0;

      if (data is Map) {
        ratingsList = data['data'] is List ? data['data'] as List : [];
        average = (data['averageRating'] ?? 0).toDouble();
        total = (data['totalRatings'] ?? ratingsList.length) as int;
      } else if (data is List) {
        ratingsList = data;
        total = ratingsList.length;
      }

      final ratings = ratingsList
          .whereType<Map>()
          .map((r) => Rating.fromMap(r as Map<String, dynamic>))
          .toList();

      if (kDebugMode)
        debugPrint('✅ Fetched ${ratings.length} ratings, avg: $average');
      return (ratings: ratings, average: average, total: total);
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching company ratings: $e');
      return (ratings: <Rating>[], average: 0.0, total: 0);
    }
  }

  /// ✅ جلب التقييمات اللي أعطتها الشركة للمرشحين
  Future<List<Rating>> getCompanyGivenRatings(String companyId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.companyGivenRatings(companyId),
      );
      final data = response.data;
      final list = (data is Map && data['data'] is List)
          ? data['data'] as List
          : (data is List ? data : []);
      return list
          .whereType<Map>()
          .map((r) => Rating.fromMap(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error fetching given ratings: $e');
      return [];
    }
  }

  /// ✅ حذف تقييم
  Future<bool> deleteRating(String ratingId) async {
    try {
      final response = await _apiClient.delete(
        ApiConstants.ratingById(ratingId),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error deleting rating: $e');
      return false;
    }
  }
}
