import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await ApiClient.get('/users/me', requiresAuth: true);
      final data = await handleResponse(response, (map) => map);
      
      final user = data['user'] as Map<String, dynamic>? ?? data;
      
      // Update store with fetched info
      final name = user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
      final email = user['email']?.toString() ?? '';
      final photoUrl = ApiClient.resolveImageUrl(user['avatar']?.toString() ?? user['photoUrl']?.toString());
      final bio = user['bio']?.toString();
      final location = user['location']?.toString();
      final phone = user['phone']?.toString();
      final role = user['role']?.toString();
      final title = user['classification']?.toString() ?? user['title']?.toString() ?? '';
      
      List<String>? tradesmanServices;
      if (user['services'] is List) {
        tradesmanServices = (user['services'] as List).map((e) => e.toString()).toList();
      }
      
      RecruitmentSyncStore.instance.updateUserProfile(
        fullName: name,
        title: title,
        email: email,
        phone: phone,
        location: location,
        about: bio,
        role: role,
        tradesmanServices: tradesmanServices,
        profileImage: photoUrl,
      );
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? location,
    String? bio,
    String? classification,
    String? gender,
    int? experience,
    List<String>? services,
    String? criminalRecordUrl,
    String? avatar,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['fullName'] = fullName;
      if (phone != null) body['phone'] = phone;
      if (location != null) body['location'] = location;
      if (bio != null) body['bio'] = bio;
      if (classification != null) body['classification'] = classification;
      if (gender != null) body['gender'] = gender;
      if (experience != null) body['experience'] = experience;
      if (services != null && services.isNotEmpty) body['services'] = services;
      if (criminalRecordUrl != null) body['criminalRecordUrl'] = criminalRecordUrl;
      if (avatar != null) body['avatar'] = avatar;

      final response = await ApiClient.put('/users/me', requiresAuth: true, body: body);
      final data = await handleResponse(response, (map) => map);
      
      final user = data['user'] as Map<String, dynamic>? ?? data;
      
      final name = user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
      final email = user['email']?.toString() ?? '';
      final photoUrl = ApiClient.resolveImageUrl(user['avatar']?.toString() ?? user['photoUrl']?.toString());
      final bioStr = user['bio']?.toString();
      final locationStr = user['location']?.toString();
      final phoneStr = user['phone']?.toString();
      final roleStr = user['role']?.toString();
      final titleStr = user['classification']?.toString() ?? user['title']?.toString() ?? '';
      
      List<String>? tradesmanServices;
      if (user['services'] is List) {
        tradesmanServices = (user['services'] as List).map((e) => e.toString()).toList();
      }
      
      RecruitmentSyncStore.instance.updateUserProfile(
        fullName: name,
        title: titleStr,
        email: email,
        phone: phoneStr,
        location: locationStr,
        about: bioStr,
        role: roleStr,
        tradesmanServices: tradesmanServices,
        profileImage: photoUrl,
      );
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final response = await ApiClient.multipartRequest(
        '/images/upload',
        method: 'POST',
        files: {'file': filePath},
        requiresAuth: true,
      );
      final data = await handleResponse(response, (map) => map);
      return data['url']?.toString() ?? data['imageUrl']?.toString() ?? data['data']?['url']?.toString();
    } catch (e) {
      return null;
    }
  }
}
