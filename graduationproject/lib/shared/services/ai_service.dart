import '../../data/api/api_client.dart';

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  Future<dynamic> smartSearch(String query) async {
    try {
      final response = await ApiClient.get('/ai/smart-search', queryParams: {'q': query});
      final data = await handleResponse(response, (map) => map);
      return data['data'] ?? data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> scoreCv({
    required List<String> userSkills,
    required String userBio,
    required String jobTitle,
    required String jobDescription,
  }) async {
    try {
      final response = await ApiClient.post('/ai/score-cv', body: {
        'userSkills': userSkills,
        'userBio': userBio,
        'jobTitle': jobTitle,
        'jobDescription': jobDescription,
      });
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> generateJobDesc({
    required String title,
    required String category,
    required String experience,
    required String location,
  }) async {
    try {
      final response = await ApiClient.post('/ai/generate-job-desc', body: {
        'title': title,
        'category': category,
        'experience': experience,
        'location': location,
      });
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> generateCoverLetter({
    required String userName,
    required List<String> userSkills,
    required String userExperience,
    required String jobTitle,
  }) async {
    try {
      final response = await ApiClient.post('/ai/cover-letter', body: {
        'userName': userName,
        'userSkills': userSkills,
        'userExperience': userExperience,
        'jobTitle': jobTitle,
      });
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
