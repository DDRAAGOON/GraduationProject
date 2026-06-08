import 'dart:convert';
import '../../data/api/api_client.dart';

class RatingService {
  RatingService._();
  static final RatingService instance = RatingService._();

  Future<List<Map<String, dynamic>>> getCompanyRatings(String companyId) async {
    try {
      final response = await ApiClient.get('/ratings/company/$companyId');
      final data = await handleResponse(response, (map) => map);
      final List<dynamic> ratings = data['data'] ?? data['ratings'] ?? data ?? [];
      return ratings.cast<Map<String, dynamic>>();
    } catch (e) {
      // If endpoint doesn't exist yet, return empty list instead of crashing
      return [];
    }
  }

  Future<Map<String, dynamic>> postCompanyRating(String companyId, String text) async {
    try {
      final response = await ApiClient.post(
        '/ratings/company/$companyId',
        body: {'text': text},
        requiresAuth: true,
      );
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
