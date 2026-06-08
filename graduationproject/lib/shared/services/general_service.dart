import '../../data/api/api_client.dart';

class GeneralService {
  GeneralService._();
  static final GeneralService instance = GeneralService._();

  Future<Map<String, dynamic>> getTranslations(String lang) async {
    try {
      final response = await ApiClient.get('/translations', queryParams: {'lang': lang});
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await ApiClient.get('/content/stats');
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> contactSupport({
    required String name,
    required String email,
    required String subject,
    required String message,
    String preferredContact = 'email',
  }) async {
    try {
      final response = await ApiClient.post('/support/contact', body: {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
        'preferredContact': preferredContact,
      });
      await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
