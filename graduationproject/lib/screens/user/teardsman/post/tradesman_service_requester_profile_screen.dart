import 'package:flutter/material.dart';

import 'package:graduationproject/screens/company/widgets/company_applicant_avatar.dart';
import 'package:graduationproject/screens/user/teardsman/Tradesman_Messages/chat_tradesman.dart';
import 'package:graduationproject/screens/user/teardsman/post/tradesman_rating_prompt.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';

const _defaultChatAvatar =
    'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg';

class TradesmanServiceRequesterProfileScreen extends StatefulWidget {
  const TradesmanServiceRequesterProfileScreen({
    super.key,
    required this.application,
  });

  final RecruitmentApplication application;

  @override
  State<TradesmanServiceRequesterProfileScreen> createState() =>
      _TradesmanServiceRequesterProfileScreenState();
}

class _TradesmanServiceRequesterProfileScreenState
    extends State<TradesmanServiceRequesterProfileScreen> {
  String _formatDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _translateStatus(String status, bool isAr) {
    final low = status.toLowerCase();
    if (isAr) {
      if (low.contains('accept') || low.contains('hire')) return 'مقبول';
      if (low.contains('reject') || low.contains('declin')) return 'مرفوض';
      if (low.contains('pend')) return 'قيد المراجعة';
      if (low.contains('appli')) return 'تم التقديم';
      return status;
    }
    if (low.contains('accept') || low.contains('hire')) return 'Accepted';
    if (low.contains('reject') || low.contains('declin')) return 'Rejected';
    if (low.contains('pend')) return 'Pending';
    if (low.contains('appli')) return 'Applied';
    return status;
  }

  Future<void> _updateStatus(BuildContext context, String status) async {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    try {
      await RecruitmentSyncService.instance.updateStatus(
        applicationId: widget.application.id,
        status: status,
      );
      if (!context.mounted) return;

      if (status == 'Accepted') {
        await TradesmanRatingPrompt.showAcceptanceFlow(
          context: context,
          personName: widget.application.userName,
          applicationId: widget.application.id,
          targetUserId: widget.application.userId,
        );
        if (context.mounted) Navigator.pop(context);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'تم تحديث حالة الطلب' : 'Request status updated',
          ),
        ),
      );
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'فشل تحديث الحالة' : 'Failed to update status',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatTradesman(
          userId: widget.application.userId,
          name: widget.application.userName,
          image: _defaultChatAvatar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final application = widget.application;
    final appliedDate = _formatDate(application.updatedAt);
    final problemDescription = (application.about ?? '').trim();
    final statusLabel = _translateStatus(application.status, isAr);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.tr(en: 'Service requester', ar: 'طالب الخدمة'),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: RecruitmentSyncStore.instance,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  color: const Color(0xFF213E75),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CompanyApplicantAvatar(
                          seed: application.id,
                          radius: 40,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          application.userName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if ((application.location ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            application.location!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.tr(en: 'Application date', ar: 'تاريخ التقديم'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              appliedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.tr(en: 'Status', ar: 'الحالة'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                statusLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _updateStatus(context, 'Accepted'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(t.tr(en: 'Accept', ar: 'قبول')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _updateStatus(context, 'Rejected'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFEA4335),
                                ),
                                child: Text(t.tr(en: 'Reject', ar: 'رفض')),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _openChat(context),
                            icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white),
                            label: Text(
                              t.tr(en: 'Message', ar: 'مراسلة'),
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  t.tr(en: 'Request details', ar: 'تفاصيل الطلب'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                _InfoTile(
                  label: t.tr(en: 'Work title', ar: 'عنوان العمل'),
                  value: application.jobTitle,
                ),
                const SizedBox(height: 12),
                _InfoTile(
                  label: t.tr(en: 'Problem description', ar: 'وصف المشكلة'),
                  value: problemDescription.isNotEmpty
                      ? problemDescription
                      : t.tr(
                          en: 'No description provided',
                          ar: 'لا يوجد وصف للمشكلة',
                        ),
                ),
                if ((application.phone ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _InfoTile(
                    label: t.tr(en: 'Phone', ar: 'الهاتف'),
                    value: application.phone!,
                  ),
                ],
                if ((application.email ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _InfoTile(
                    label: t.tr(en: 'Email', ar: 'البريد الإلكتروني'),
                    value: application.email!,
                  ),
                ],
                if (application.gender != null &&
                    application.gender!.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _InfoTile(
                    label: t.tr(en: 'Gender', ar: 'الجنس'),
                    value: application.gender!,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFB5ADAD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
