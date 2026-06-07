import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

class DashboardService {
  final ApiClient _apiClient;

  DashboardService(this._apiClient);

  Future<Map<String, dynamic>> getStats() async {
    final response = await _apiClient.post(ApiConstants.dashboardStats);
    return response.data;
  }

  Future<Map<String, dynamic>> getApplicantsSummary() async {
    final response = await _apiClient.post(ApiConstants.applicantsSummary);
    return response.data;
  }
}
