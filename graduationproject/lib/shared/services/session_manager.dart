import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyIsLoggedIn = 'is_logged_in_company';
  static const String _keyCompanyEmail = 'company_email';
  static const String _keyCompanyName = 'company_name';
  static const String _keyCompanyPhoto = 'company_photo';

  static Future<void> saveCompanySession({
    required String email,
    required String name,
    String? photoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyCompanyEmail, email);
    await prefs.setString(_keyCompanyName, name);
    if (photoPath != null) {
      await prefs.setString(_keyCompanyPhoto, photoPath);
    }
  }

  static Future<bool> isCompanyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
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
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyCompanyEmail);
    await prefs.remove(_keyCompanyName);
    await prefs.remove(_keyCompanyPhoto);
  }
}
