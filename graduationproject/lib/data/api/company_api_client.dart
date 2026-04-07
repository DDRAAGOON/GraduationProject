// Skeleton HTTP client for company API calls (extend when wiring `http`).

import 'api_endpoints.dart';

// Skeleton API client.
// This is intentionally not wired to `package:http` yet (no dependency added).
// When you provide endpoints/JSON + confirm the HTTP library you want, we will implement
// real requests and JSON parsing here.
final class CompanyApiClient {
  const CompanyApiClient({
    this.baseUrl = ApiEndpoints.baseUrl,
  });

  final String baseUrl;

  Future<List<Map<String, dynamic>>> fetchJobs() {
    return Future.error(
      UnsupportedError('CompanyApiClient.fetchJobs is not implemented yet.'),
    );
  }

  Future<List<Map<String, dynamic>>> fetchApplicantsByJobId(String jobId) {
    return Future.error(
      UnsupportedError(
        'CompanyApiClient.fetchApplicantsByJobId is not implemented yet.',
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchMessageThreads() {
    return Future.error(
      UnsupportedError('CompanyApiClient.fetchMessageThreads is not implemented yet.'),
    );
  }
}

