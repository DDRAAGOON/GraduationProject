import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../job/job_models.dart';

class JobService {
  final ApiClient _apiClient;

  JobService(this._apiClient);

  Future<List<Job>> getJobs() async {
    final response = await _apiClient.get(ApiConstants.jobs);
    final List<dynamic> data = response.data;
    return data.map((json) => Job.fromJson(json)).toList();
  }

  Future<List<Job>> getCompanyJobs(String companyId) async {
    final response = await _apiClient.get(ApiConstants.companyJobs(companyId));
    final List<dynamic> data = response.data;
    return data.map((json) => Job.fromJson(json)).toList();
  }

  Future<Job> getJobDetails(String id) async {
    final response = await _apiClient.get(ApiConstants.jobDetails(id));
    return Job.fromJson(response.data);
  }

  Future<Job> createJob(CreateJobRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.jobs,
      data: request.toJson(),
    );
    return Job.fromJson(response.data);
  }

  Future<Job> updateJob(String id, CreateJobRequest request) async {
    final response = await _apiClient.put(
      ApiConstants.jobDetails(id),
      data: request.toJson(),
    );
    return Job.fromJson(response.data);
  }

  Future<void> deleteJob(String id) async {
    await _apiClient.delete(ApiConstants.jobDetails(id));
  }

  Future<Map<String, dynamic>> getJobStats() async {
    final response = await _apiClient.get(ApiConstants.jobStats);
    return response.data;
  }
}
