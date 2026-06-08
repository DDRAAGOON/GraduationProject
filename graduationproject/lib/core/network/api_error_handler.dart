import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppException implements Exception {
  final String messageEn;
  final String messageAr;
  final String? techDetails;
  final bool isCritical;

  AppException({
    required this.messageEn,
    required this.messageAr,
    this.techDetails,
    this.isCritical = false,
  });

  @override
  String toString() {
    return 'AppException: $messageEn ($messageAr) ${techDetails != null ? "[$techDetails]" : ""}';
  }
  
  String localizedMessage(bool isAr) => isAr ? messageAr : messageEn;
}

class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is SocketException) {
      return AppException(
        messageEn: 'No Internet connection. Please check your network and try again.',
        messageAr: 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مرة أخرى.',
      );
    } else if (error is AppException) {
      return error; // Already parsed
    } else {
      return AppException(
        messageEn: 'An unexpected error occurred. Please try again later.',
        messageAr: 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقاً.',
        techDetails: error.toString(),
        isCritical: true,
      );
    }
  }

  static AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          messageEn: 'Connection timed out. Please check your network and try again.',
          messageAr: 'انتهت مهلة الاتصال. يرجى التحقق من الشبكة والمحاولة مرة أخرى.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        // Extract server message if available
        String? serverMsgEn;
        String? serverMsgAr;
        if (responseData is Map<String, dynamic>) {
          serverMsgEn = responseData['message']?.toString() ?? responseData['error']?.toString();
          // Assuming the server might return 'messageAr' if implemented, otherwise fallback to messageEn
          serverMsgAr = responseData['messageAr']?.toString() ?? responseData['message']?.toString() ?? responseData['error']?.toString();
        }

        switch (statusCode) {
          case 400:
            return AppException(
              messageEn: serverMsgEn ?? 'Bad request. Please check the entered data.',
              messageAr: serverMsgAr ?? 'طلب غير صالح. يرجى التحقق من البيانات المدخلة.',
            );
          case 401:
          case 403:
            return AppException(
              messageEn: serverMsgEn ?? 'Session expired or invalid credentials. Please log in again.',
              messageAr: serverMsgAr ?? 'انتهت الجلسة أو بيانات الدخول غير صالحة. يرجى تسجيل الدخول مرة أخرى.',
            );
          case 404:
            return AppException(
              messageEn: serverMsgEn ?? 'Requested resource not found.',
              messageAr: serverMsgAr ?? 'المورد المطلوب غير موجود.',
            );
          case 500:
          case 502:
          case 503:
          case 504:
            return AppException(
              messageEn: 'Internal server error. Our team has been notified.',
              messageAr: 'خطأ داخلي في الخادم. تم إبلاغ فريقنا.',
              techDetails: serverMsgEn ?? error.message,
              isCritical: true,
            );
          default:
            return AppException(
              messageEn: serverMsgEn ?? 'Something went wrong. Please try again.',
              messageAr: serverMsgAr ?? 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
              techDetails: 'Status code: $statusCode',
            );
        }
      case DioExceptionType.cancel:
        return AppException(
          messageEn: 'Request was cancelled.',
          messageAr: 'تم إلغاء الطلب.',
        );
      case DioExceptionType.connectionError:
        return AppException(
          messageEn: 'Failed to connect to the server. Please check your internet connection.',
          messageAr: 'فشل الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت الخاص بك.',
        );
      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException) {
          return AppException(
            messageEn: 'No Internet connection. Please check your network and try again.',
            messageAr: 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مرة أخرى.',
          );
        }
        return AppException(
          messageEn: 'An unexpected network error occurred.',
          messageAr: 'حدث خطأ غير متوقع في الشبكة.',
          techDetails: error.message,
          isCritical: true,
        );
    }
  }
  
  static void logError(String context, dynamic error) {
    if (kReleaseMode) {
      // In production, only log critical errors cleanly
      if (error is AppException && error.isCritical) {
         debugPrint('[JOBITO-ERROR] $context: ${error.messageEn} | Tech Details: ${error.techDetails}');
      } else if (error is! AppException) {
         debugPrint('[JOBITO-ERROR] $context: Unhandled Exception -> $error');
      }
    } else {
      // In debug mode, log everything
      debugPrint('[JOBITO-ERROR] $context: $error');
    }
  }
}
