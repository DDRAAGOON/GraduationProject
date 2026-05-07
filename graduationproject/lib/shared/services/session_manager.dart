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

  static Future<void> saveCompanyPhoto(String photoPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCompanyPhoto, photoPath);
  }

  static Future<void> logoutCompany() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedInCompany);
    await prefs.remove(_keyCompanyEmail);
    await prefs.remove(_keyCompanyName);
    await prefs.remove(_keyCompanyPhoto);
    await prefs.remove('company_employee');
    await prefs.remove('company_industry');
    await prefs.remove('company_aboutEn');
    await prefs.remove('company_aboutAr');
    await prefs.remove('company_locations');
    await prefs.remove('company_techStack');
    await prefs.remove('company_foundedDay');
    await prefs.remove('company_foundedMonth');
    await prefs.remove('company_foundedYear');
    await prefs.remove('company_category');
    await prefs.remove('company_benefits');
    await prefs.remove('company_commercialRegister');
    await prefs.remove('company_nationalNumber');
  }

  static Future<void> saveCompanyFullProfile({
    required String employee,
    required String industry,
    required String aboutEn,
    required String aboutAr,
    required List<String> locations,
    required List<String> techStack,
    required int foundedDay,
    required int foundedMonth,
    required int foundedYear,
    required String category,
    required List<String> benefits,
    required String commercialRegister,
    required String nationalNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_employee', employee);
    await prefs.setString('company_industry', industry);
    await prefs.setString('company_aboutEn', aboutEn);
    await prefs.setString('company_aboutAr', aboutAr);
    await prefs.setStringList('company_locations', locations);
    await prefs.setStringList('company_techStack', techStack);
    await prefs.setInt('company_foundedDay', foundedDay);
    await prefs.setInt('company_foundedMonth', foundedMonth);
    await prefs.setInt('company_foundedYear', foundedYear);
    await prefs.setString('company_category', category);
    await prefs.setStringList('company_benefits', benefits);
    await prefs.setString('company_commercialRegister', commercialRegister);
    await prefs.setString('company_nationalNumber', nationalNumber);
  }

  static Future<Map<String, dynamic>> getCompanyFullProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'employee': prefs.getString('company_employee') ?? '',
      'industry': prefs.getString('company_industry') ?? '',
      'aboutEn': prefs.getString('company_aboutEn') ?? '',
      'aboutAr': prefs.getString('company_aboutAr') ?? '',
      'locations': prefs.getStringList('company_locations') ?? <String>[],
      'techStack': prefs.getStringList('company_techStack') ?? <String>[],
      'foundedDay': prefs.getInt('company_foundedDay') ?? 0,
      'foundedMonth': prefs.getInt('company_foundedMonth') ?? 0,
      'foundedYear': prefs.getInt('company_foundedYear') ?? 0,
      'category': prefs.getString('company_category') ?? '',
      'benefits': prefs.getStringList('company_benefits') ?? <String>[],
      'commercialRegister': prefs.getString('company_commercialRegister') ?? '',
      'nationalNumber': prefs.getString('company_nationalNumber') ?? '',
    };
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
