import 'api_endpoints.dart';
import 'package:dio/dio.dart';

final class CompanyApiClient {
  CompanyApiClient({
    this.baseUrl = ApiEndpoints.baseUrl,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 12),
            receiveTimeout: const Duration(seconds: 12),
            headers: const {'Content-Type': 'application/json'},
          ),
        );

  final String baseUrl;
  final Dio _dio;
  String? _accessToken;

  void setToken(String token) {
    _accessToken = token;
  }

  Options get _authOptions => Options(
        headers: _accessToken == null
            ? null
            : <String, dynamic>{'Authorization': 'Bearer $_accessToken'},
      );

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiEndpoints.login,
      data: <String, dynamic>{'email': email, 'password': password},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> fetchJobs() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiEndpoints.jobs,
      options: _authOptions,
    );
    return (response.data as List<dynamic>)
        .map((dynamic e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchApplications() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiEndpoints.applications,
      options: _authOptions,
    );
    return (response.data as List<dynamic>)
        .map((dynamic e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<Map<String, dynamic>> createJob({
    required String title,
    required String companyName,
    required String location,
    required String salaryRange,
    required String type,
    required List<String> tags,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiEndpoints.jobs,
      data: <String, dynamic>{
        'title': title,
        'companyName': companyName,
        'location': location,
        'salaryRange': salaryRange,
        'type': type,
        'tags': tags,
      },
      options: _authOptions,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> createApplication({
    required String jobId,
    required String userName,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiEndpoints.applications,
      data: <String, dynamic>{'jobId': jobId, 'userName': userName},
      options: _authOptions,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    final String path = ApiEndpoints.applicationStatus.replaceFirst(
      '{id}',
      applicationId,
    );
    final Response<dynamic> response = await _dio.patch<dynamic>(
      path,
      data: <String, dynamic>{'status': status},
      options: _authOptions,
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiEndpoints.messages,
      options: _authOptions,
    );
    return (response.data as List<dynamic>)
        .map((dynamic e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> sendMessage(String text) async {
    await _dio.post<dynamic>(
      ApiEndpoints.messages,
      data: <String, dynamic>{'text': text},
      options: _authOptions,
    );
  }
}
