import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/constants/api_constants.dart';

class ImageService {
  final ApiClient _apiClient;

  ImageService(this._apiClient);

  Future<String> uploadImage(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });

      final response = await _apiClient.post(
        ApiConstants.uploadImage,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response.data['url'];
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    try {
      await _apiClient.put(
        ApiConstants.updateProfileImage,
        data: {'url': imageUrl},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updateBannerImage(String imageUrl) async {
    try {
      await _apiClient.put(
        ApiConstants.updateBannerImage,
        data: {'url': imageUrl},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<String>> getEntityImages(String type, String id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.entityImages(type, id),
      );
      return List<String>.from(response.data);
    } catch (_) {
      return []; // silent
    }
  }

  Future<String?> getUserProfileImage(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userProfileImage(userId),
      );
      return response.data['url'];
    } catch (_) {
      return null; // silent
    }
  }

  Future<void> deleteImage(String imageId) async {
    try {
      await _apiClient.delete(ApiConstants.deleteImage(imageId));
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
