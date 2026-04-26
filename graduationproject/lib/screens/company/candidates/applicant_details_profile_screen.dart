// Read-only applicant profile details for recruiters.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/models/job.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/models/message_thread.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyApplicantDetailsProfileScreen extends StatelessWidget {
  const CompanyApplicantDetailsProfileScreen({
    super.key,
    required this.applicant,
  });

  final Applicant applicant;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final syncStore = RecruitmentSyncStore.instance;
    final companyStore = CompanyStore.instance;

    return ListenableBuilder(
      listenable: syncStore,
      builder: (context, _) {
        final application = syncStore.applications.firstWhere(
          (a) => a.id == applicant.id,
          orElse: () => RecruitmentApplication(
            id: applicant.id,
            jobId: applicant.jobId,
            jobTitle: applicant.role,
            companyName: '',
            userName: applicant.fullName,
            status: applicant.stage,
            updatedAt: DateTime.now(),
          ),
        );

        final job = companyStore.jobs.firstWhere(
          (j) => j.id == applicant.jobId,
          orElse: () => Job.mock(),
        );

        final acceptedCount = syncStore.applications
            .where((a) => a.jobId == job.id && a.status.toLowerCase().contains('hire'))
            .length;

        return AppScaffold(
          title: t.applicantDetails,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: _buildMainContent(context, t, isAr),
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: _buildSidebar(context, t, isAr, application, job, acceptedCount),
                      ),
                    ),
                  ],
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSidebar(context, t, isAr, application, job, acceptedCount),
                  const SizedBox(height: 24),
                  _buildMainContent(context, t, isAr),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, AppLocalizations t, bool isAr) {
    // ... (rest of main content stays same)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF49769F), width: 2),
                  ),
                ),
                child: Text(
                  isAr ? 'ملف المتقدم' : 'Applicant Profile',
                  style: const TextStyle(
                    color: Color(0xFF49769F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Personal Info
        _buildSectionTitle(isAr ? 'المعلومات الشخصية' : 'Personal Information'),
        const SizedBox(height: 16),
        _buildGridInfo([
          _Detail(label: isAr ? 'الاسم الكامل' : 'Full Name', value: applicant.fullName),
          _Detail(label: isAr ? 'الجنس' : 'Gender', value: applicant.gender ?? (isAr ? 'لم يحدد' : 'Not specified')),
          _Detail(label: isAr ? 'تاريخ الميلاد' : 'Birth Date', value: applicant.birthDate ?? (isAr ? 'غير متوفر' : 'Not available')),
          _Detail(label: isAr ? 'اللغات' : 'Languages', value: applicant.languages.isEmpty ? (isAr ? 'العربية' : 'Arabic') : applicant.languages.join(', ')),
        ]),

        const SizedBox(height: 32),
        Divider(color: Colors.grey.withOpacity(0.1)),
        const SizedBox(height: 32),

        // Professional Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(isAr ? 'المعلومات المهنية' : 'Professional Information'),
            if (applicant.hasCv)
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(isAr ? 'السيرة الذاتية' : 'Curriculum Vitae (CV)'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.picture_as_pdf, size: 64, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          Text(isAr ? 'جاري عرض ملف السيرة الذاتية للمتقدم...' : 'Opening applicant CV file...'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(isAr ? 'إغلاق' : 'Close'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
                label: Text(
                  isAr ? 'عرض السيرة الذاتية' : 'View CV',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailRow(isAr ? 'نبذة عني' : 'About Me', applicant.about ?? (isAr ? 'لا يوجد نبذة تعريفية متاحة لهذا المتقدم.' : 'No about available.')),
        const SizedBox(height: 24),
        _buildGridInfo([
          _Detail(label: isAr ? 'الوظيفة الحالية' : 'Current Job', value: applicant.role),
          _Detail(label: isAr ? 'سنوات الخبرة' : 'Years of Experience', value: '${applicant.experienceYears} ${isAr ? 'سنوات' : 'years'}'),
          _Detail(label: isAr ? 'أعلى مؤهل علمي' : 'Highest Education', value: applicant.education ?? (isAr ? 'غير متوفر' : 'Not available')),
        ]),
        const SizedBox(height: 16),
        _buildSkills(isAr ? 'المهارات' : 'Skills', isAr),
      ],
    );
  }

  Widget _buildSidebar(
    BuildContext context, 
    AppLocalizations t, 
    bool isAr, 
    RecruitmentApplication application,
    Job job,
    int acceptedCount,
  ) {
    final capacity = job.capacity ?? 10;
    final remaining = (capacity - acceptedCount).clamp(0, capacity);

    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CompanyApplicantAvatar(seed: applicant.id, radius: 40),
                const SizedBox(height: 16),
                Text(
                  applicant.fullName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  applicant.role,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                
                // Hiring Progress Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isAr ? 'تقدم التوظيف' : 'Hiring Progress',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$acceptedCount/$capacity',
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: acceptedCount / capacity,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.hiredProgressMsg(acceptedCount, capacity),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isAr ? 'اليوم' : 'Today', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(isAr ? 'الحالة الحالية' : 'Current Status', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isAr ? 'نموت سيف' : 'Namoot Saif', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        application.status,
                        style: TextStyle(
                          fontSize: 11, 
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: isAr ? 'قبول' : 'Accept',
                        color: const Color(0xFF4285F4),
                        onPressed: () => _handleStatusChange(context, 'Hired', isAr),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        label: isAr ? 'رفض' : 'Reject',
                        color: const Color(0xFFEA4335),
                        onPressed: () => _handleStatusChange(context, 'Declined', isAr),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        label: isAr ? 'انتظار' : 'Wait',
                        color: const Color(0xFFFBBC05),
                        onPressed: () => _handleStatusChange(context, 'Waitlist', isAr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'بيانات التواصل' : 'Contact Info',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final thread = MessageThread(
                        id: 'thread_${applicant.id}',
                        title: applicant.fullName,
                        subtitle: isAr ? 'بدء محادثة جديدة...' : 'Starting a new conversation...',
                        lastTimeLabelEn: 'Now',
                        lastTimeLabelAr: 'الآن',
                      );
                      Navigator.of(context).pushNamed(AppRoutes.companyChatThread, arguments: thread);
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: Text(isAr ? 'مراسلة المتقدم' : 'Message Applicant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5145CD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.email_outlined, color: Colors.teal, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'البريد الإلكتروني' : 'Email Address',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          Text(
                            applicant.email,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleStatusChange(BuildContext context, String newStatus, bool isAr) {
    final t = AppLocalizations.of(context);
    RecruitmentSyncStore.instance.companyUpdateApplicationStatus(
      applicationId: applicant.id,
      nextStatus: newStatus,
    );

    if (newStatus == 'Hired') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Color(0xFF4285F4), size: 48),
          title: Text(t.applicantAcceptedTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.hiredCongratulation(applicant.fullName),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notification_important, color: Colors.blue, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.evaluationReminder,
                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t.isAr ? 'حسناً' : 'Understood'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${t.hiredStatusUpdate} $newStatus',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildGridInfo(List<_Detail> details) {
    return Wrap(
      spacing: 40,
      runSpacing: 20,
      children: details.map((d) => SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(d.label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(d.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14)),
      ],
    );
  }

  Widget _buildSkills(String label, bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 12),
        if (applicant.skills.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue.withOpacity(0.1)),
            ),
            child: Text(
              isAr ? 'لا توجد مهارات مسجلة' : 'No skills registered',
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: applicant.skills.map((s) => Chip(label: Text(s))).toList(),
          ),
      ],
    );
  }
}

class _Detail {
  final String label;
  final String value;
  _Detail({required this.label, required this.value});
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
