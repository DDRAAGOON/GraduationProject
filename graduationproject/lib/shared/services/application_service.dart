import 'dart:convert';
import '../../data/api/api_client.dart';
import '../state/recruitment_sync_store.dart';
import '../models/applicant.dart';

class ApplicationService {
  ApplicationService._();
  static final ApplicationService instance = ApplicationService._();

  Future<void> applyToJob({
    required String jobId,
    String? coverLetter,
    String? portfolioUrl,
    String? address,
    String? resumeUrl,
    bool isServiceJob = false,
  }) async {
    try {
      Map<String, dynamic> body;

      if (isServiceJob) {
        // Use the exact payload requested by the backend developer, 
        // but also include 'job_id' to bypass the database not-null constraint error.
        body = {
          'job_id': jobId,
          'tradesmanId': jobId,
          'address': address ?? '',
          'problemDetails': coverLetter ?? '',
        };
      } else {
        // Standard job application payload
        body = {
          'job_id': jobId,
        };
        if (coverLetter != null && coverLetter.isNotEmpty) body['coverLetter'] = coverLetter;
        if (portfolioUrl != null && portfolioUrl.isNotEmpty) body['portfolioUrl'] = portfolioUrl;
        if (address != null && address.isNotEmpty) body['address'] = address;
        if (resumeUrl != null && resumeUrl.isNotEmpty) body['resumeUrl'] = resumeUrl;
      }

      // If the backend has a new endpoint for tradesman, we might need to change the URL here.
      // For now, we'll try the same endpoint, but if the backend developer provided a different one,
      // you can change '/applications' to the new one (e.g. '/tradesman/apply').
      String endpoint = isServiceJob ? '/applications' : '/applications'; 

      final response = await ApiClient.post(endpoint, requiresAuth: true, body: body);
      await handleResponse(response, (map) => map);
      await getMyApplications(); // refresh applications list
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RecruitmentApplication>> getMyApplications() async {
    try {
      final response = await ApiClient.get('/applications/my', requiresAuth: true);
      
      List list = [];
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final decoded = jsonDecode(response.body);
          if (decoded is List) {
            list = decoded;
          } else if (decoded is Map) {
            list = decoded['applications'] as List? ?? 
                   decoded['data'] as List? ?? 
                   decoded['items'] as List? ?? 
                   decoded['results'] as List? ?? [];
            if (list.isEmpty) {
              // Fallback: find the first value that is a List
              for (var value in decoded.values) {
                if (value is List) {
                  list = value;
                  break;
                }
              }
              // Nested data fallback
              if (list.isEmpty && decoded['data'] is Map) {
                for (var value in (decoded['data'] as Map).values) {
                  if (value is List) {
                    list = value;
                    break;
                  }
                }
              }
            }
          }
        }
      } else {
        await handleResponse(response, (map) => map); // Use handleResponse just to throw the ApiException
      }
      
      final parsed = list.map((a) {
        final jobObj = a['job'] as Map<String, dynamic>?;
        final companyObj = jobObj?['company'] as Map<String, dynamic>? ?? a['company'] as Map<String, dynamic>?;
        
        final fallbackId = a.hashCode.toString() + DateTime.now().microsecondsSinceEpoch.toString();
        
        return RecruitmentApplication(
          id: a['_id']?.toString() ?? a['id']?.toString() ?? a['applicationId']?.toString() ?? a['application_id']?.toString() ?? fallbackId,
          jobId: a['jobId']?.toString() ?? a['job_id']?.toString() ?? jobObj?['id']?.toString() ?? '',
          userId: a['userId']?.toString() ?? a['user']?.toString() ?? '',
          jobTitle: a['jobTitle']?.toString() ?? jobObj?['title']?.toString() ?? 'Job',
          companyName: a['companyName']?.toString() ?? companyObj?['name']?.toString() ?? 'Company',
          userName: RecruitmentSyncStore.instance.currentUserName,
          status: a['status']?.toString() ?? 'pending',
          updatedAt: a['updatedAt'] != null ? DateTime.tryParse(a['updatedAt']) ?? DateTime.now() : DateTime.now(),
        );
      }).toList();

      // Only keeping my applications locally to match what user expects.
      RecruitmentSyncStore.instance.replaceFromRemote(jobs: null, applications: parsed, messages: null);
      return parsed;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RecruitmentApplication>> getJobApplicants(String jobId) async {
    try {
      final response = await ApiClient.get('/applications', requiresAuth: true);
      
      List list = [];
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          final decoded = jsonDecode(response.body);
          if (decoded is List) {
            list = decoded;
          } else if (decoded is Map) {
            list = decoded['applications'] as List? ?? 
                   decoded['data'] as List? ?? 
                   decoded['items'] as List? ?? 
                   decoded['results'] as List? ?? [];
            if (list.isEmpty) {
              for (var value in decoded.values) {
                if (value is List) {
                  list = value;
                  break;
                }
              }
              if (list.isEmpty && decoded['data'] is Map) {
                for (var value in (decoded['data'] as Map).values) {
                  if (value is List) {
                    list = value;
                    break;
                  }
                }
              }
            }
          }
        }
      } else {
        await handleResponse(response, (map) => map);
      }
      
      final parsed = list.map((a) {
        final jobObj = a['job'] as Map<String, dynamic>?;
        final companyObj = jobObj?['company'] as Map<String, dynamic>? ?? a['company'] as Map<String, dynamic>?;
        final userObj = a['user'] as Map<String, dynamic>?;
        
        final fallbackId = a.hashCode.toString() + DateTime.now().microsecondsSinceEpoch.toString();
        
        return RecruitmentApplication(
          id: a['_id']?.toString() ?? a['id']?.toString() ?? a['applicationId']?.toString() ?? a['application_id']?.toString() ?? fallbackId,
          jobId: a['jobId']?.toString() ?? a['job_id']?.toString() ?? jobObj?['id']?.toString() ?? '',
          userId: a['userId']?.toString() ?? userObj?['_id']?.toString() ?? userObj?['id']?.toString() ?? a['user']?.toString() ?? '',
          jobTitle: a['jobTitle']?.toString() ?? jobObj?['title']?.toString() ?? 'Job',
          companyName: a['companyName']?.toString() ?? companyObj?['name']?.toString() ?? 'Company',
          userName: userObj?['name']?.toString() ?? userObj?['fullName']?.toString() ?? a['userName']?.toString() ?? 'User',
          status: a['status']?.toString() ?? 'pending',
          updatedAt: a['updatedAt'] != null ? DateTime.tryParse(a['updatedAt']) ?? DateTime.now() : DateTime.now(),
        );
      }).where((app) => app.jobId == jobId || jobId.isEmpty).toList();
      
      // Store them in the sync store without overriding 'my' applications
      // For now we just add them to the store's applications list if they aren't there
      final store = RecruitmentSyncStore.instance;
      for (var app in parsed) {
        final existingIndex = store.applications.indexWhere((e) => e.id == app.id);
        if (existingIndex >= 0) {
          store.applications[existingIndex] = app;
        } else {
          store.applications.add(app);
        }
      }
      
      return parsed;
    } catch (e) {
      // It's possible the endpoint doesn't exist for normal users, return empty
      return [];
    }
  }

  Future<Map<String, dynamic>> getApplicationStatus(String jobId) async {
    try {
      final response = await ApiClient.get('/applications/status/$jobId', requiresAuth: true);
      return await handleResponse(response, (map) => map);
    } catch (e) {
      rethrow;
    }
  }
}
