import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/utils/image_helper.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
import 'tradesman_apply_job_screen.dart';

class TradesmanJobDetailsScreen extends StatefulWidget {
  const TradesmanJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  State<TradesmanJobDetailsScreen> createState() =>
      _TradesmanJobDetailsScreenState();
}

class _TradesmanJobDetailsScreenState extends State<TradesmanJobDetailsScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final List<Map<String, dynamic>> _customerReviews = [
    {'name': 'محمد', 'rating': 5, 'comment': 'عمل ممتاز وخدمة سريعة جدًا.'},
    {
      'name': 'ليلى',
      'rating': 4,
      'comment': 'احترافيين في العمل ومراجعة ممتازة.',
    },
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) return;

    setState(() {
      _customerReviews.insert(0, {
        'name': 'أنت',
        'rating': _selectedRating == 0 ? 5 : _selectedRating,
        'comment': comment,
      });
      _reviewController.clear();
      _selectedRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;
    final job = widget.job;
    final publishDate = job.publishedAt.toLocal().toString().split(' ').first;
    final deadlineText = job.deadline != null
        ? job.deadline!.format(context)
        : 'غير محدد';
    final availableCount = (job.capacity - job.acceptedCount).clamp(0, 9999);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(t.tr(en: 'Job Details', ar: 'تفاصيل الوظيفة')),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionCard(
                context,
                title: 'التصنيف',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.12),
                          backgroundImage: job.companyLogoUrl != null
                              ? getAppImageProvider(job.companyLogoUrl!)
                              : null,
                          child: job.companyLogoUrl == null
                              ? Icon(
                                  job.logoIcon ?? Icons.business,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 26,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job.companyName,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildBadge(job.category, const Color(0xFF2563EB)),
                        if (job.specialTag != null &&
                            job.specialTag!.isNotEmpty)
                          _buildBadge(job.specialTag!, const Color(0xFFFF7A2A)),
                        ...job.type
                            .split(RegExp(r'[•,;]'))
                            .where((value) => value.trim().isNotEmpty)
                            .map(
                              (value) => _buildBadge(
                                value.trim(),
                                _getJobTypeColor(value.trim()),
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                context,
                title: 'تفاصيل الوظيفة',
                child: Column(
                  children: [
                    _buildSimpleCapacityBar(context, job, availableCount),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'تاريخ النشر',
                      value: publishDate,
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.event_available_outlined,
                      label: 'الانتهاء',
                      value: deadlineText,
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.work_outline,
                      label: 'نوع الوظيفة',
                      value: job.type,
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      label: 'الموقع',
                      value: job.location,
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.attach_money,
                      label: 'الراتب',
                      value: job.salaryRange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                context,
                title: 'المهارات',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      (job.tags.isNotEmpty ? job.tags : job.qualifications).map(
                        (item) {
                          final normalized = item.trim();
                          if (normalized.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFF7A2A,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              normalized,
                              style: TextStyle(
                                color: const Color(0xFFFF7A2A),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                context,
                title: 'التقييمات والآراء',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اضف تقييمك',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Container(
                              width: 96,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF7A2A,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '2.4',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFF7A2A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'تقييم العملاء',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(5, (index) {
                                      final starIndex = index + 1;
                                      return IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedRating = starIndex;
                                          });
                                        },
                                        icon: Icon(
                                          starIndex <= _selectedRating
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 28,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 120,
                                    child: TextField(
                                      controller: _reviewController,
                                      maxLines: 6,
                                      minLines: 5,
                                      textAlignVertical: TextAlignVertical.top,
                                      decoration: InputDecoration(
                                        hintText: 'اكتب تعليقك هنا...',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.45),
                                        ),
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withValues(alpha: 0.7),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                        suffixIcon: IconButton(
                                          onPressed: _submitReview,
                                          icon: const Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Color(0xFF4A6ED1),
                                            size: 20,
                                          ),
                                          tooltip: 'إرسال',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'التعليقات',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._customerReviews.map(
                      (review) => _buildReviewCard(review),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppButton(
                label: t.tr(en: 'Apply Now', ar: 'قدّم الآن'),
                backgroundColor: const Color(0xFF4A6ED1),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TradesmanApplyJobScreen(job: job),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSimpleCapacityBar(
    BuildContext context,
    RecruitmentJob job,
    int availableCount,
  ) {
    final acceptedRatio = job.capacity == 0
        ? 0.0
        : (job.acceptedCount / job.capacity).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${job.acceptedCount} تم قبول من ${job.capacity} متاح',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: acceptedRatio,
            minHeight: 6,
            backgroundColor: Theme.of(
              context,
            ).dividerColor.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation<Color>(
              acceptedRatio >= 1.0 ? Colors.green : const Color(0xFFFF7A2A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating = review['rating'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['name'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    size: 14,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'] as String,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A2A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFFF7A2A), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return Colors.green;
      case 'part-time':
        return Colors.blue;
      case 'remote':
        return Colors.purple;
      case 'freelance':
        return Colors.teal;
      case 'one-time':
        return Colors.amber;
      case 'internship':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
