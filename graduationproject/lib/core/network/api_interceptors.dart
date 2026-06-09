import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'secure_storage.dart';
import '../../app/router/app_router.dart';

/// [ApiInterceptors] attaches the JWT token and language header to every
/// outgoing request, and handles session expiry (HTTP 401) globally by
/// deleting the stored token and redirecting the user to the Login screen.
class ApiInterceptors extends Interceptor {
  /// A reference to the app-level navigator key used for global navigation
  /// without a [BuildContext]. Set this from [App] before any request is made.
  static GlobalKey<NavigatorState>? navigatorKey;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getToken();
    final lang = await SecureStorage.getLang();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['x-lang'] = lang;
    options.headers['Content-Type'] = 'application/json';

    // ✅ Logging في وضع التطوير
    if (kDebugMode) {
      debugPrint('🌐 API Request: ${options.method} ${options.uri}');
      debugPrint('🔐 Token: ${token != null ? "Present" : "Missing"}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ✅ Logging الاستجابات الناجحة
    if (kDebugMode) {
      debugPrint(
        '✅ API Response: ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ✅ Logging الأخطاء
    if (kDebugMode) {
      debugPrint(
        '❌ API Error: ${err.response?.statusCode} ${err.requestOptions.uri}',
      );
      debugPrint('📝 Error Message: ${err.message}');
    }

    // ✅ التعامل مع خطأ 401 (انتهاء صلاحية التوكن)
    if (err.response?.statusCode == 401) {
      _handleUnauthorized();
    }
    // ✅ التعامل مع خطأ 403 (غير مصرح)
    else if (err.response?.statusCode == 403) {
      if (kDebugMode) {
        debugPrint('⚠️ Access Denied: ${err.requestOptions.uri}');
      }
    }
    // ✅ التعامل مع أخطاء السيرفر (500, 502, 503)
    else if (err.response?.statusCode != null &&
        err.response!.statusCode! >= 500) {
      if (kDebugMode) {
        debugPrint('🔥 Server Error: ${err.response?.statusCode}');
      }
    }

    super.onError(err, handler);
  }

  /// ✅ معالجة خطأ 401: حذف التوكن والتوجيه لشاشة الدخول
  void _handleUnauthorized() {
    // حذف التوكن منتهي الصلاحية
    SecureStorage.deleteToken();

    if (kDebugMode) {
      debugPrint('🚪 Session Expired: Redirecting to login');
    }

    // التوجيه العالمي لشاشة الدخول
    final nav = navigatorKey?.currentState;
    if (nav != null) {
      // ✅ التحقق من أن المستخدم ليس بالفعل في شاشة الدخول
      final currentRoute = nav.context
          .findAncestorStateOfType<NavigatorState>();

      nav.pushNamedAndRemoveUntil(
        AppRoutes.companyLogin,
        (route) => false, // إزالة جميع الشاشات من الـ stack
      );
    } else {
      if (kDebugMode) {
        debugPrint('⚠️ Warning: navigatorKey is not set!');
      }
    }
  }
}
