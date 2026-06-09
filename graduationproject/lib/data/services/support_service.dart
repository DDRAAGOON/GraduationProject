import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';
import '../models/support/support_models.dart';

class SupportService {
  final ApiClient _apiClient;

  SupportService(this._apiClient);

  Future<List<dynamic>> getHelpCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.supportHelpCategories);
      return response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<HelpArticle>> searchHelpArticles(String query) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.supportHelpArticles,
        queryParameters: {'q': query},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => HelpArticle.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<HelpArticle> getHelpArticleDetails(String id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.supportHelpArticleById(id),
      );
      return HelpArticle.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> contactSupport(SupportContactRequest request) async {
    try {
      await _apiClient.post(
        ApiConstants.supportContact,
        data: request.toJson(),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<dynamic>> getContentServices() async {
    try {
      final response = await _apiClient.get(ApiConstants.contentServices);
      return response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getContentStats() async {
    try {
      final response = await _apiClient.get(ApiConstants.contentStats);
      return response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
