import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "https://yourapi.com/login",//API
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Login failed");
    }
  }
}