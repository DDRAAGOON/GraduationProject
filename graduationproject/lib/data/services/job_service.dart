import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/job/job_models.dart';

class JobService {
  final ApiClient _apiClient;

  JobService(this._apiClient);

  Future<List<Job>> getJobs({Map<String, dynamic>? filters}) async {
    final response = await _apiClient.get(ApiConstants.jobs, queryParameters: filters);
    final List<dynamic> data = response.data;
    return data.map((json) => Job.fromJson(json)).toList();
  }

  Future<List<String>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.jobCategories);
    return List<String>.from(response.data);
  }

  Future<Job> getJobDetails(String id) async {
    final response = await _apiClient.get(ApiConstants.jobById(id));
    return Job.fromJson(response.data);
  }

  Future<List<Job>> getSimilarJobs(String id) async {
    final response = await _apiClient.get(ApiConstants.similarJobs(id));
    final List<dynamic> data = response.data;
    return data.map((json) => Job.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> getJobAnalytics(String id) async {
    final response = await _apiClient.get(ApiConstants.jobAnalytics(id));
    return response.data;
  }

  Future<void> recordJobView(String id, String sessionId) async {
    await _apiClient.post(
      ApiConstants.jobView(id),
      data: {'sessionId': sessionId},
    );
  }

  Future<Job> createJob(CreateJobRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.jobs,
      data: request.toJson(),
    );
    return Job.fromJson(response.data);
  }

  Future<void> deleteJob(String id) async {
    await _apiClient.delete(ApiConstants.jobById(id));
  }

  Future<Job> updateJob(String id, CreateJobRequest request) async {
    final response = await _apiClient.patch(
      ApiConstants.jobById(id),
      data: request.toJson(),
    );
    return Job.fromJson(response.data);
  }
}
