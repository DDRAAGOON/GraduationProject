import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';

class AiSmartService {
  final ApiClient _apiClient;

  AiSmartService(this._apiClient);

  Future<List<dynamic>> smartSearch(
    String query, {
    String? location,
    String? category,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.aiSmartSearch,
        queryParameters: {
          'q': query,
          if (location != null) 'location': location,
          if (category != null) 'category': category,
        },
      );
      return response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<String>> autoTag(String title, {String? description}) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.aiAutoTag,
        data: {
          'title': title,
          if (description != null) 'description': description,
        },
      );
      return List<String>.from(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> scoreCv({
    required List<String> userSkills,
    String? userBio,
    required String jobTitle,
    String? jobDescription,
  }) async {
    try {
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
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> generateJobDescription({
    required String title,
    required String category,
    String? experience,
    String? location,
  }) async {
    try {
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
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> generateCoverLetter({
    required String userName,
    required List<String> userSkills,
    String? userExperience,
    required String jobTitle,
  }) async {
    try {
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
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
