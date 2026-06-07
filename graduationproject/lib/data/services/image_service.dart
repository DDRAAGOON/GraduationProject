import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

class ImageService {
  final ApiClient _apiClient;

  ImageService(this._apiClient);

  Future<String> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });

    final response = await _apiClient.post(
      ApiConstants.uploadImage,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data['url'];
  }

  Future<void> updateProfileImage(String imageUrl) async {
    await _apiClient.put(
      ApiConstants.updateProfileImage,
      data: {'url': imageUrl},
    );
  }

  Future<void> updateBannerImage(String imageUrl) async {
    await _apiClient.put(
      ApiConstants.updateBannerImage,
      data: {'url': imageUrl},
    );
  }

  Future<List<String>> getEntityImages(String type, String id) async {
    final response = await _apiClient.get(ApiConstants.entityImages(type, id));
    return List<String>.from(response.data);
  }

  Future<String?> getUserProfileImage(String userId) async {
    final response = await _apiClient.get(ApiConstants.userProfileImage(userId));
    return response.data['url'];
  }

  Future<void> deleteImage(String imageId) async {
    await _apiClient.delete(ApiConstants.deleteImage(imageId));
  }
}
