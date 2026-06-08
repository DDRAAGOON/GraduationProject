import 'dart:convert';
import '../../data/api/api_client.dart';

class CompanyService {
  CompanyService._();
  static final CompanyService instance = CompanyService._();

  Future<List<dynamic>> getCompanies({String? search, int page = 1}) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': '10',
      };
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      final response = await ApiClient.get('/companies', queryParams: queryParams);
      final data = await handleResponse(response, (map) => map);
      return data['data'] ?? data['companies'] ?? data ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCompanyProfile() async {
    try {
      final response = await ApiClient.get('/companies/my/profile', requiresAuth: true);
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await ApiClient.get('/companies/my/dashboard-summary', requiresAuth: true);
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
