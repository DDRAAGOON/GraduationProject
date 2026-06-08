import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../../shared/models/job.dart';

class FavoriteService {
  final ApiClient _apiClient;

  FavoriteService(this._apiClient);

  Future<void> toggleFavorite(String jobId) async {
    try {
      await _apiClient.post(ApiConstants.toggleFavorite(jobId));
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<Job>> getFavorites() async {
    try {
      final response = await _apiClient.get(ApiConstants.favorites);
      final List<dynamic> data = response.data;
      return data.map((json) => Job.fromMap(json)).toList();
    } catch (_) {
      // Silent failure for favorites
      return [];
    }
  }
}
