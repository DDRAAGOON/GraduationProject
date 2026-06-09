import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/application/application_models.dart';

class ApplicationService {
  final ApiClient _apiClient;

  ApplicationService(this._apiClient);

  Future<JobApplication> applyForJob(CreateApplicationRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.applications,
        data: request.toJson(),
      );
      return JobApplication.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<JobApplication>> getMyApplications() async {
    try {
      final response = await _apiClient.get(ApiConstants.myApplications);
      final List<dynamic> data = response.data;
      return data.map((json) => JobApplication.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<JobApplication>> getJobApplications(String jobId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.jobApplications(jobId),
      );
      final List<dynamic> data = response.data;
      return data.map((json) => JobApplication.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<JobApplication> getApplicationDetails(String id) async {
    try {
      final response = await _apiClient.get(ApiConstants.applicationById(id));
      return JobApplication.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<JobApplication> updateApplicationStatus(
    String id,
    String status,
  ) async {
    try {
      final response = await _apiClient.patch(
        ApiConstants.applicationStatus(id),
        data: {'status': status},
      );
      return JobApplication.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
