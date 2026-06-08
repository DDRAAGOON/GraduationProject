import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

class DashboardService {
  final ApiClient _apiClient;

  DashboardService(this._apiClient);

  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await _apiClient.post(ApiConstants.dashboardStats);
      return response.data ?? {};
    } catch (_) {
      // Silent failure for non-critical stats
      return {};
    }
  }

  Future<Map<String, dynamic>> getApplicantsSummary() async {
    try {
      final response = await _apiClient.post(ApiConstants.applicantsSummary);
      return response.data ?? {};
    } catch (_) {
      // Silent failure
      return {};
    }
  }
}
