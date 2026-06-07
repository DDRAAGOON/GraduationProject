import 'package:dio/dio.dart';
import 'secure_storage.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();
    final lang = await SecureStorage.getLang();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['x-lang'] = lang;
    options.headers['Content-Type'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle globally (e.g., redirect to login on 401)
    if (err.response?.statusCode == 401) {
      SecureStorage.deleteToken();
    }
    super.onError(err, handler);
  }
}
