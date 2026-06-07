import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/support/support_models.dart';

class SupportService {
  final ApiClient _apiClient;

  SupportService(this._apiClient);

  Future<List<dynamic>> getHelpCategories() async {
    final response = await _apiClient.get(ApiConstants.supportHelpCategories);
    return response.data;
  }

  Future<List<HelpArticle>> searchHelpArticles(String query) async {
    final response = await _apiClient.get(
      ApiConstants.supportHelpArticles,
      queryParameters: {'q': query},
    );
    final List<dynamic> data = response.data;
    return data.map((json) => HelpArticle.fromJson(json)).toList();
  }

  Future<HelpArticle> getHelpArticleDetails(String id) async {
    final response = await _apiClient.get(ApiConstants.supportHelpArticleById(id));
    return HelpArticle.fromJson(response.data);
  }

  Future<void> contactSupport(SupportContactRequest request) async {
    await _apiClient.post(
      ApiConstants.supportContact,
      data: request.toJson(),
    );
  }

  Future<List<dynamic>> getContentServices() async {
    final response = await _apiClient.get(ApiConstants.contentServices);
    return response.data;
  }

  Future<Map<String, dynamic>> getContentStats() async {
    final response = await _apiClient.get(ApiConstants.contentStats);
    return response.data;
  }
}
