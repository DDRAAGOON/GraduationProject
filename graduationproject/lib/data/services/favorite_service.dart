import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../job/job_models.dart';

class FavoriteService {
  final ApiClient _apiClient;

  FavoriteService(this._apiClient);

  Future<void> toggleFavorite(String jobId) async {
    await _apiClient.post(ApiConstants.toggleFavorite(jobId));
  }

  Future<List<Job>> getFavorites() async {
    final response = await _apiClient.get(ApiConstants.favorites);
    final List<dynamic> data = response.data;
    return data.map((json) => Job.fromJson(json)).toList();
  }
}
