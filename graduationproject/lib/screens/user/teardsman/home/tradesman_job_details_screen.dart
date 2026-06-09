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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            Text(
              t.tr(en: 'Job Details', ar: 'تفاصيل الوظيفة'),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48), // Balancing the back button
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              // Header Card
              _buildSectionCard(
                context,
                title: 'التصنيف',
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: job.companyLogoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image(
                                    image: getAppImageProvider(
                                      job.companyLogoUrl!,
                                    )!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  job.logoIcon ?? Icons.business,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                job.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job.companyName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.end,
                      children: [
                        _buildBadge(job.category, const Color(0xFF2563EB)),
                        if (job.specialTag != null &&
                            job.specialTag!.isNotEmpty)
                          _buildBadge(job.specialTag!, const Color(0xFF142C66)),
                        ...job.type
                            .split(RegExp(r'[•,;]'))
                            .where((v) => v.trim().isNotEmpty)
                            .map((v) => _buildBadge(v.trim(), Colors.black26)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Job Details Card
              _buildSectionCard(
                context,
                title: 'تفاصيل الوظيفة',
                child: Column(
                  children: [
                    _buildSimpleCapacityBar(context, job),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'تاريخ النشر',
                      publishDate,
                    ),
                    _buildInfoRow(
                      Icons.event_available_outlined,
                      'الانتهاء',
                      deadlineText,
                    ),
                    _buildInfoRow(Icons.work_outline, 'نوع الوظيفة', job.type),
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      'الموقع',
                      job.location,
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      'الراتب',
                      job.salaryRange,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Skills Card
              _buildSectionCard(
                context,
                title: 'المهارات',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.end,
                  children:
                      (job.tags.isNotEmpty ? job.tags : job.qualifications).map(
                        (skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              skill.trim(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Reviews Card
              _buildSectionCard(
                context,
                title: 'التقييمات والآراء',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRatingBox(),
                        const Text(
                          'اضف تقييمك',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRatingStars(),
                    const SizedBox(height: 12),
                    _buildReviewInput(),
                    const SizedBox(height: 20),
                    const Text(
                      'التعليقات',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._customerReviews.map(
                      (review) => _buildReviewItem(review),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              AppButton(
                label: job.acceptedCount < job.capacity
                    ? t.tr(en: 'Apply Now', ar: 'قدّم الآن')
                    : t.tr(en: 'Job Closed', ar: 'الوظيفة مغلقة'),
                backgroundColor: job.acceptedCount < job.capacity
                    ? const Color(0xFF142C66)
                    : Colors.grey,
                onPressed: job.acceptedCount < job.capacity
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => TradesmanApplyJobScreen(job: job),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 40),
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
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF213E75),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCapacityBar(BuildContext context, RecruitmentJob job) {
    final ratio = job.capacity == 0
        ? 0.0
        : (job.acceptedCount / job.capacity).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'المقبولين ${job.acceptedCount} من ${job.capacity}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFFFF7A2A),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              ratio >= 1.0 ? Colors.greenAccent : const Color(0xFFFF7A2A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildRatingBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.star, color: Colors.amber, size: 18),
          SizedBox(width: 4),
          Text(
            '2.4',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => setState(() => _selectedRating = index + 1),
          icon: Icon(
            index < _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 28,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }

  Widget _buildReviewInput() {
    return TextField(
      controller: _reviewController,
      maxLines: 3,
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'اكتب تعليقك هنا...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: _submitReview,
          icon: const Icon(Icons.send, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: 12,
                    color: i < review['rating'] ? Colors.amber : Colors.white24,
                  ),
                ),
              ),
              Text(
                review['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review['comment'],
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
