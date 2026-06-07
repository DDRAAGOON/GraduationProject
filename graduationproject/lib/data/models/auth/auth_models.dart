class LoginRequest {
  final String email;
  final String password;
  final String? role;

  LoginRequest({
    required this.email,
    required this.password,
    this.role,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    if (role != null) 'role': role,
  };
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String role;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.role = 'user',
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
    'role': role,
  };
}

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String role;
  final String name;
  final String email;
  final String? photoUrl;

  User({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      role: json['role'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }
}
