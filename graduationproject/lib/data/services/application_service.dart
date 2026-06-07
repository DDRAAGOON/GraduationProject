import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/application/application_models.dart';

class ApplicationService {
  final ApiClient _apiClient;

  ApplicationService(this._apiClient);

  Future<JobApplication> applyForJob(CreateApplicationRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.applications,
      data: request.toJson(),
    );
    return JobApplication.fromJson(response.data);
  }

  Future<List<JobApplication>> getMyApplications() async {
    final response = await _apiClient.get(ApiConstants.myApplications);
    final List<dynamic> data = response.data;
    return data.map((json) => JobApplication.fromJson(json)).toList();
  }

  Future<List<JobApplication>> getJobApplications(String jobId) async {
    final response = await _apiClient.get(ApiConstants.jobApplications(jobId));
    final List<dynamic> data = response.data;
    return data.map((json) => JobApplication.fromJson(json)).toList();
  }

  Future<JobApplication> getApplicationDetails(String id) async {
    final response = await _apiClient.get(ApiConstants.applicationById(id));
    return JobApplication.fromJson(response.data);
  }

  Future<JobApplication> updateApplicationStatus(String id, String status) async {
    final response = await _apiClient.patch(
      ApiConstants.applicationStatus(id),
      data: {'status': status},
    );
    return JobApplication.fromJson(response.data);
  }
}
