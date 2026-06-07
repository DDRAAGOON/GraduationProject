import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/company/company_models.dart';

class CompanyService {
  final ApiClient _apiClient;

  CompanyService(this._apiClient);

  Future<List<Company>> getCompanies() async {
    final response = await _apiClient.get(ApiConstants.companies);
    final List<dynamic> data = response.data;
    return data.map((json) => Company.fromJson(json)).toList();
  }

  Future<List<Company>> getPendingCompanies() async {
    final response = await _apiClient.get(ApiConstants.pendingCompanies);
    final List<dynamic> data = response.data;
    return data.map((json) => Company.fromJson(json)).toList();
  }

  Future<Company> getCompanyDetails(String id) async {
    final response = await _apiClient.get(ApiConstants.companyById(id));
    return Company.fromJson(response.data);
  }

  Future<Company> updateCompanyStatus(String id, String status) async {
    final response = await _apiClient.patch(
      ApiConstants.updateCompanyStatus(id),
      data: {'status': status},
    );
    return Company.fromJson(response.data);
  }
}
