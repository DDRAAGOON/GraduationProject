import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyIsLoggedInCompany = 'is_logged_in_company';
  static const String _keyCompanyEmail = 'company_email';
  static const String _keyCompanyName = 'company_name';
  static const String _keyCompanyPhoto = 'company_photo';

  static const String _keyIsLoggedInUser = 'is_logged_in_user';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhoto = 'user_photo';

  static Future<void> saveCompanySession({
    required String email,
    required String name,
    String? photoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedInCompany, true);
    await prefs.setString(_keyCompanyEmail, email);
    await prefs.setString(_keyCompanyName, name);
    if (photoPath != null) {
      await prefs.setString(_keyCompanyPhoto, photoPath);
    }
  }

  static Future<bool> isCompanyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedInCompany) ?? false;
  }

  static Future<Map<String, String?>> getCompanyData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyCompanyEmail),
      'name': prefs.getString(_keyCompanyName),
      'photo': prefs.getString(_keyCompanyPhoto),
    };
  }

  static Future<void> logoutCompany() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedInCompany);
    await prefs.remove(_keyCompanyEmail);
    await prefs.remove(_keyCompanyName);
    await prefs.remove(_keyCompanyPhoto);
  }

  static Future<void> saveUserSession({
    required String email,
    required String name,
    String? photoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedInUser, true);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserName, name);
    if (photoPath != null) {
      await prefs.setString(_keyUserPhoto, photoPath);
    }
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedInUser) ?? false;
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_keyUserEmail),
      'name': prefs.getString(_keyUserName),
      'photo': prefs.getString(_keyUserPhoto),
    };
  }

  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedInUser);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserPhoto);
  }
}
