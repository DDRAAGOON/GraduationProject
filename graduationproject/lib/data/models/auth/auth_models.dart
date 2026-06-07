class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
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
    return AuthResponse(
      token: json['token'] ?? json['jwtToken'] ?? '',
      user: User.fromJson(json['user'] ?? json),
    );
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
      mSkills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      mBio: json['bio'],
    );
  }
}
