import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/job/job_models.dart';

class JobService {
  final ApiClient _apiClient;

  JobService(this._apiClient);

  Future<List<Job>> getJobs() async {
    try {
      final response = await _apiClient.get(ApiConstants.jobs);
      final List<dynamic> data = response.data;
      return data.map((json) => Job.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<Job>> getCompanyJobs(String companyId) async {
    try {
      final response = await _apiClient.get(ApiConstants.companyJobs(companyId));
      final List<dynamic> data = response.data;
      return data.map((json) => Job.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Job> getJobDetails(String id) async {
    try {
      final response = await _apiClient.get(ApiConstants.jobById(id));
      return Job.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Job> createJob(CreateJobRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.jobs,
        data: request.toJson(),
      );
      return Job.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Job> updateJob(String id, CreateJobRequest request) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.jobById(id),
        data: request.toJson(),
      );
      return Job.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      await _apiClient.delete(ApiConstants.jobById(id));
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getJobStats() async {
    try {
      final response = await _apiClient.get(ApiConstants.jobStats);
      return response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
