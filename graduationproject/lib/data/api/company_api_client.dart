import 'api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
        ) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => debugPrint(o.toString()),
    ));
  }

  final String baseUrl;
  final Dio _dio;
  String? _accessToken;
  bool get hasToken => _accessToken != null && _accessToken!.isNotEmpty;

  void setToken(String token) {
    _accessToken = token;
  }

  void clearToken() {
    _accessToken = null;
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

  Future<Map<String, dynamic>> googleLogin({
    required String idToken,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiEndpoints.googleLogin,
      data: <String, dynamic>{'idToken': idToken},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiEndpoints.register,
      data: <String, dynamic>{
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      },
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
    required String category,
    int requiredCount = 1,
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
        'category': category,
        'requiredCount': requiredCount,
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
