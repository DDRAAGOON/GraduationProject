import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentJobDetailsScreen extends StatelessWidget {
  const RecruitmentJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return Colors.green;
      case 'part-time':
        return Colors.blue;
      case 'remote':
        return Colors.purple;
      case 'freelance':
      case 'freelancer':
        return Colors.teal;
      case 'one-time':
        return Colors.amber;
      case 'internship':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  String _translateLabel(String label, bool isAr) {
    if (!isAr) return label;
    final low = label.trim().toLowerCase();
    switch (low) {
      case 'full-time':
      case 'full time':
        return 'دوام كامل';
      case 'part-time':
      case 'part time':
        return 'دوام جزئي';
      case 'freelance':
      case 'freelancer':
        return 'عمل حر';
      case 'remote':
        return 'عن بعد';
      case 'internship':
        return 'تدريب';
      case 'one-time':
      case 'one time':
        return 'مرة واحدة';
      case 'service':
      case 'services':
        return 'خدمة';
      case 'technical':
        return 'تقني';
      case 'non-technical':
        return 'غير تقني';
      default:
        return label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'تفاصيل الوظيفة' : 'Job Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    backgroundImage: job.companyLogoUrl != null ? getAppImageProvider(job.companyLogoUrl!) : null,
                    child: job.companyLogoUrl == null
                        ? Icon(Icons.business, size: 40, color: Theme.of(context).primaryColor)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    job.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.companyName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildHeaderTag(context, Icons.location_on_outlined, job.location),
                      _buildHeaderTag(context, Icons.work_outline, _translateLabel(job.type, isAr)),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress & Capacity
                  _buildSectionTitle(context, isAr ? 'نظرة عامة على التقديم' : 'Application Overview'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isAr ? 'المقاعد المطلوبة: ${job.capacity}' : 'Required Capacity: ${job.capacity}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              isAr 
                                ? 'المقبولون: ${job.acceptedCount}' 
                                : 'Accepted: ${job.acceptedCount}',
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: job.capacity > 0 ? (job.acceptedCount / job.capacity).clamp(0.0, 1.0) : 0,
                            backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                            color: job.acceptedCount >= job.capacity ? Colors.green : Theme.of(context).primaryColor,
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Salary
                  if (job.salaryRange.isNotEmpty && job.salaryRange.toLowerCase() != 'all') ...[
                    _buildDetailRow(context, Icons.payments_outlined, isAr ? 'الراتب المتوقع' : 'Expected Salary', job.salaryRange),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  if (job.description.trim().isNotEmpty) ...[
                    _buildSectionTitle(context, isAr ? 'وصف الوظيفة' : 'Job Description'),
                    const SizedBox(height: 8),
                    Text(
                      job.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tags / Skills
                  if (job.tags.isNotEmpty) ...[
                    _buildSectionTitle(context, isAr ? 'المهارات المطلوبة' : 'Required Skills'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.tags.map((tag) => Chip(
                        label: Text(_translateLabel(tag, isAr)),
                        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        side: BorderSide.none,
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Responsibilities
                  if (job.responsibilities.isNotEmpty) ...[
                    _buildSectionTitle(context, isAr ? 'المسؤوليات المهنية' : 'Key Responsibilities'),
                    const SizedBox(height: 12),
                    ...job.responsibilities.map((item) => _buildBulletPoint(context, item)),
                    const SizedBox(height: 24),
                  ],

                  // Qualifications
                  if (job.qualifications.isNotEmpty) ...[
                    _buildSectionTitle(context, isAr ? 'المؤهلات المطلوبة' : 'Required Qualifications'),
                    const SizedBox(height: 12),
                    ...job.qualifications.map((item) => _buildBulletPoint(context, item)),
                    const SizedBox(height: 24),
                  ],

                  // Benefits
                  if (job.benefits.isNotEmpty) ...[
                    _buildSectionTitle(context, isAr ? 'المزايا والفوائد' : 'Perks & Benefits'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: job.benefits.map((item) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(item, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],

                  AppButton(
                    label: isAr ? 'قدّم طلبك الآن' : 'Apply for this Job',
                    backgroundColor: const Color(0xFF4A6ED1),
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.userJobApplication,
                      arguments: job,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTag(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
