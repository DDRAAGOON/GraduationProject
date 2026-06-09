import 'dart:convert';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String phone;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'role': role,
    'phone': phone,
  };
}

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    String token =
        json['token'] ??
        json['jwtToken'] ??
        json['access_token'] ??
        json['accessToken'] ??
        '';

    Map<String, dynamic> userJson = json['user'] ?? json;

    if (token.isNotEmpty && json['user'] == null) {
      final parts = token.split('.');
      if (parts.length == 3) {
        String payload = parts[1];
        payload = payload.padRight((payload.length + 3) & ~3, '=');
        try {
          final String decoded = utf8.decode(base64Url.decode(payload));
          final Map<String, dynamic> tokenData = jsonDecode(decoded);

          userJson = {
            'id': tokenData['sub'] ?? tokenData['id'] ?? '',
            'email': tokenData['email'] ?? '',
            'role': tokenData['role'] ?? '',
            'fullName': tokenData['name'] ?? tokenData['fullName'] ?? '',
            'photoUrl': tokenData['avatar'] ?? tokenData['picture'],
          };
        } catch (_) {}
      }
    }

    return AuthResponse(token: token, user: User.fromJson(userJson));
  }
}

class User {
  final String id;
  final String? role;
  final String? fullName;
  final String email;
  final String? photoUrl;
  final List<String>? mSkills;
  final String? mBio;

  User({
    required this.id,
    this.role,
    this.fullName,
    required this.email,
    this.photoUrl,
    this.mSkills,
    this.mBio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? json['userId']?.toString() ?? '',
      role: json['role'],
      fullName: json['fullName'] ?? json['name'],
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? json['picture'],
      mSkills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : null,
      mBio: json['bio'],
    );
  }
}
