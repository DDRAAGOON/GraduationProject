import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/company/company_models.dart';

class CompanyService {
  final ApiClient _apiClient;

  CompanyService(this._apiClient);

  Future<List<Company>> getCompanies() async {
    try {
      final response = await _apiClient.get(ApiConstants.companies);
      final List<dynamic> data = response.data;
      return data.map((json) => Company.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<Company>> getPendingCompanies() async {
    try {
      final response = await _apiClient.get(ApiConstants.pendingCompanies);
      final List<dynamic> data = response.data;
      return data.map((json) => Company.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Company> getCompanyDetails(String id) async {
    try {
      final response = await _apiClient.get(ApiConstants.companyById(id));
      return Company.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Company> updateCompanyStatus(String id, String status) async {
    try {
      final response = await _apiClient.patch(
        ApiConstants.updateCompanyStatus(id),
        data: {'status': status},
      );
      return Company.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
