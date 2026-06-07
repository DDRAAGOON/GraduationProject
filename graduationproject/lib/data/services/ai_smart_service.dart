import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

class AiSmartService {
  final ApiClient _apiClient;

  AiSmartService(this._apiClient);

  Future<List<dynamic>> smartSearch(String query, {String? location, String? category}) async {
    final response = await _apiClient.get(
      ApiConstants.aiSmartSearch,
      queryParameters: {
        'q': query,
        if (location != null) 'location': location,
        if (category != null) 'category': category,
      },
    );
    return response.data;
  }

  Future<List<String>> autoTag(String title, {String? description}) async {
    final response = await _apiClient.post(
      ApiConstants.aiAutoTag,
      data: {
        'title': title,
        if (description != null) 'description': description,
      },
    );
    return List<String>.from(response.data);
  }

  Future<Map<String, dynamic>> scoreCv({
    required List<String> userSkills,
    String? userBio,
    required String jobTitle,
    String? jobDescription,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.aiScoreCv,
      data: {
        'userSkills': userSkills,
        if (userBio != null) 'userBio': userBio,
        'jobTitle': jobTitle,
        if (jobDescription != null) 'jobDescription': jobDescription,
      },
    );
    return response.data;
  }

  Future<String> generateJobDescription({
    required String title,
    required String category,
    String? experience,
    String? location,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.aiGenerateJobDesc,
      data: {
        'title': title,
        'category': category,
        if (experience != null) 'experience': experience,
        if (location != null) 'location': location,
      },
    );
    return response.data['description'] ?? '';
  }

  Future<String> generateCoverLetter({
    required String userName,
    required List<String> userSkills,
    String? userExperience,
    required String jobTitle,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.aiCoverLetter,
      data: {
        'userName': userName,
        'userSkills': userSkills,
        if (userExperience != null) 'userExperience': userExperience,
        'jobTitle': jobTitle,
      },
    );
    return response.data['coverLetter'] ?? '';
  }
}
