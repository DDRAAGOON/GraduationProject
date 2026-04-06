import '../api/company_api_client.dart';
import '../../shared/models/applicant.dart';
import '../../shared/models/job.dart';
import '../../shared/models/message_thread.dart';
import 'company_repository.dart';

// API implementation placeholder.
// It will be wired once you provide endpoints/JSON and confirm HTTP/serialization details.
final class ApiCompanyRepository implements CompanyRepository {
  const ApiCompanyRepository({
    required this.client,
  });

  final CompanyApiClient client;

  @override
  Future<List<Job>> fetchJobs() {
    return Future.error(
      UnimplementedError('ApiCompanyRepository.fetchJobs is not implemented yet.'),
    );
  }

  @override
  Future<List<Applicant>> fetchApplicantsByJobId(String jobId) {
    return Future.error(
      UnimplementedError(
        'ApiCompanyRepository.fetchApplicantsByJobId is not implemented yet.',
      ),
    );
  }

  @override
  Future<List<MessageThread>> fetchMessageThreads() {
    return Future.error(
      UnimplementedError(
        'ApiCompanyRepository.fetchMessageThreads is not implemented yet.',
      ),
    );
  }
}

