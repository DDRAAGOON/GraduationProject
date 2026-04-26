// [CompanyRepository] backed by the network layer.

import '../api/company_api_client.dart';
import '../../shared/models/applicant.dart';
import '../../shared/models/job.dart';
import '../../shared/models/message_thread.dart';
import 'company_repository.dart';

final class ApiCompanyRepository implements CompanyRepository {
  const ApiCompanyRepository({
    required this.client,
  });

  final CompanyApiClient client;

  @override
  Future<List<Job>> fetchJobs() async {
    final raw = await client.fetchJobs();
    return raw
        .map(
          (item) => Job(
            id: item['id']?.toString() ?? '',
            title: item['title']?.toString() ?? 'Untitled',
            companyName: item['companyName']?.toString() ?? 'Company',
            location: item['location']?.toString() ?? 'Remote',
            employmentType: item['type']?.toString() ?? 'Full-time',
            category: item['tags'] is List && (item['tags'] as List).isNotEmpty
                ? (item['tags'] as List).first.toString()
                : 'General',
            salaryRange: item['salaryRange']?.toString() ?? 'Negotiable',
          ),
        )
        .toList();
  }

  @override
  Future<List<Applicant>> fetchApplicantsByJobId(String jobId) async {
    final raw = await client.fetchApplications();
    return raw
        .where((item) => item['jobId']?.toString() == jobId)
        .map(
          (item) => Applicant(
            id: item['id']?.toString() ?? '',
            fullName: item['userName']?.toString() ?? 'Candidate',
            role: 'Candidate',
            rating: 0,
            stage: item['status']?.toString() ?? 'Applied',
            email: 'unknown@mail.com',
            phone: '-',
            location: 'N/A',
            appliedDateLabel: item['updatedAt']?.toString() ?? '',
            jobId: jobId,
          ),
        )
        .toList();
  }

  @override
  Future<List<MessageThread>> fetchMessageThreads() async {
    final raw = await client.fetchMessages();
    return raw
        .map(
          (item) => MessageThread(
            id: item['id']?.toString() ?? '',
            title: item['fromCompany'] == true ? 'Company Update' : 'Candidate',
            subtitle: item['text']?.toString() ?? '',
            lastTimeLabelEn: 'now',
            lastTimeLabelAr: 'الان',
          ),
        )
        .toList();
  }
}
