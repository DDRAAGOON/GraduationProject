import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'https://jobito-api-production.up.railway.app/api';
  
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, String>> _getHeaders({
    bool requiresAuth = false,
    String lang = 'ar',
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'x-lang': lang,
    };
    if (requiresAuth) {
      final token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<http.Response> get(
    String endpoint, {
    bool requiresAuth = false,
    Map<String, String>? queryParams,
  }) async {
    var uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return http.get(uri, headers: await _getHeaders(requiresAuth: requiresAuth));
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(requiresAuth: requiresAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(requiresAuth: requiresAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    return http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(requiresAuth: requiresAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(requiresAuth: requiresAuth),
    );
  }

  static Future<http.Response> multipartRequest(
    String endpoint, {
    required String method,
    required Map<String, String> files,
    Map<String, String>? fields,
    bool requiresAuth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest(method, uri);
    
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    headers.remove('Content-Type');
    request.headers.addAll(headers);

    if (fields != null) {
      request.fields.addAll(fields);
    }

    for (final entry in files.entries) {
      if (entry.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
      }
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  static String? resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    
    // BaseUrl is '.../api', so we need the root url for images
    final rootUrl = baseUrl.replaceAll('/api', '');
    if (path.startsWith('/')) {
      return '$rootUrl$path';
    }
    return '$rootUrl/$path';
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

Future<T> handleResponse<T>(http.Response response, T Function(Map<String, dynamic>) parser) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    if (response.body.isEmpty) return Future.value(parser({}));
    return Future.value(parser(jsonDecode(response.body)));
  }
  
  Map<String, dynamic> error = {};
  try {
    error = jsonDecode(response.body);
  } catch (_) {
    error = {'message': 'Server error: ${response.statusCode}'};
  }
  throw ApiException(
    statusCode: response.statusCode,
    message: error['message'] ?? 'خطأ غير متوقع',
  );
}
