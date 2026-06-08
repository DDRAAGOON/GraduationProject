import 'api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final class CompanyApiClient {
  CompanyApiClient({this.baseUrl = ApiEndpoints.baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: const {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint('API LOG: ${o.toString()}'),
      ),
    );
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

  Map<String, dynamic> _parseMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? role,
  }) async {
    final payload = <String, dynamic>{'email': email, 'password': password};
    if (role != null) payload['role'] = role.toLowerCase().trim();
    final response = await _dio.post<dynamic>(
      ApiEndpoints.login,
      data: payload,
    );
    return _parseMap(response.data);
  }

  Future<Map<String, dynamic>> googleLogin({required String idToken}) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.googleLogin,
      data: <String, dynamic>{'idToken': idToken},
    );
    return _parseMap(response.data);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'role': role.toLowerCase(),
      },
    );
    return _parseMap(response.data);
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    final response = await _dio.put<dynamic>(
      '/api/auth/profile',
      data: <String, dynamic>{'name': ?name, 'photoUrl': ?photoUrl},
      options: _authOptions,
    );
    return _parseMap(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchJobs() async {
    final response = await _dio.get<dynamic>(
      ApiEndpoints.jobs,
      options: _authOptions,
    );
    if (response.data is List) {
      return (response.data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchApplications() async {
    final response = await _dio.get<dynamic>(
      ApiEndpoints.applications,
      options: _authOptions,
    );
    if (response.data is List) {
      return (response.data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> createJob(Map<String, dynamic> data) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.jobs,
      data: data,
      options: _authOptions,
    );
    return _parseMap(response.data);
  }

  Future<Map<String, dynamic>> updateJob(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.patch<dynamic>(
      '${ApiEndpoints.jobs}/$id',
      data: data,
      options: _authOptions,
    );
    return _parseMap(response.data);
  }

  Future<void> deleteJob(String id) async {
    await _dio.delete<dynamic>(
      '${ApiEndpoints.jobs}/$id',
      options: _authOptions,
    );
  }

  Future<Map<String, dynamic>> createApplication({
    required String jobId,
    required String userName,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.applications,
      data: {'jobId': jobId, 'userName': userName},
      options: _authOptions,
    );
    return _parseMap(response.data);
  }

  Future<Map<String, dynamic>> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    final String path = ApiEndpoints.applicationStatus.replaceFirst(
      '{id}',
      applicationId,
    );
    final response = await _dio.patch<dynamic>(
      path,
      data: <String, dynamic>{'status': status},
      options: _authOptions,
    );
    return _parseMap(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final response = await _dio.get<dynamic>(
      ApiEndpoints.messages,
      options: _authOptions,
    );
    if (response.data is List) {
      return (response.data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return [];
  }

  Future<void> sendMessage(String text) async {
    await _dio.post<dynamic>(
      ApiEndpoints.messages,
      data: <String, dynamic>{'text': text},
      options: _authOptions,
    );
  }
}
