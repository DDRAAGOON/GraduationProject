import '../state/recruitment_sync_store.dart';

/// Tradesman-posted work shown to job seekers (service requests).
bool isTradesmanServiceJob(RecruitmentJob job) {
  final category = job.category.toLowerCase();
  final type = job.type.toLowerCase();
  return category == 'service' || category == 'tradesman' || type == 'one-time';
}
