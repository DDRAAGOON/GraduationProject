import '../../shared/mock/mock_data.dart';
import '../../shared/models/applicant.dart';
import '../../shared/models/job.dart';
import '../../shared/models/message_thread.dart';
import 'company_repository.dart';

// Mock implementation used until you provide real endpoints/JSON.
final class MockCompanyRepository implements CompanyRepository {
  const MockCompanyRepository();

  @override
  Future<List<Job>> fetchJobs() async {
    return MockData.jobs();
  }

  @override
  Future<List<Applicant>> fetchApplicantsByJobId(String jobId) async {
    // For now, mock data is not job-filtered.
    return MockData.applicants();
  }

  @override
  Future<List<MessageThread>> fetchMessageThreads() async {
    return MockData.threads();
  }
}

