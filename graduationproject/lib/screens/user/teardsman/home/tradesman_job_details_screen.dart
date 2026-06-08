import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/utils/image_helper.dart';
import 'package:graduationproject/shared/services/rating_service.dart';
import 'package:graduationproject/shared/utils/rating_utils.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
import '../../home/tabs/recruitment_ui_utils.dart';
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
  String? _selectedReportReason;
  final TextEditingController _reportDetailsController = TextEditingController();

  List<Map<String, dynamic>> _customerReviews = [];
  bool _isLoadingReviews = true;
  bool _isSubmittingReview = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final jobId = int.tryParse(widget.job.id);
    if (jobId == null) {
      if (mounted) setState(() => _isLoadingReviews = false);
      return;
    }
    setState(() => _isLoadingReviews = true);
    final reviews = await RatingService.instance.getJobRatings(jobId);
    if (!mounted) return;
    setState(() {
      _customerReviews = reviews;
      _isLoadingReviews = false;
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _reportDetailsController.dispose();
    super.dispose();
  }

  void _showReportBottomSheet(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final reasons = [
      isAr ? 'وظيفة وهمية أو احتيال (Fake Job/Scam)' : 'Fake Job/Scam',
      isAr ? 'محتوى غير مرغوب فيه (Spam)' : 'Spam',
      isAr ? 'محتوى غير لائق (Inappropriate Content)' : 'Inappropriate Content',
      isAr ? 'معلومات غير صحيحة (Incorrect Info)' : 'Incorrect Info',
      isAr ? 'أسباب أخرى (Other reasons)' : 'Other reasons',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0D1B3E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isAr ? 'إبلاغ عن وظيفة' : 'Report Job',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  isAr
                      ? 'يرجى اختيار سبب الإبلاغ لمساعدتنا في تحسين جودة المحتوى.'
                      : 'Please select a reason for reporting to help us improve content quality.',
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ...reasons.map((reason) => RadioListTile<String>(
                      title: Text(
                        reason,
                        textAlign: isAr ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: reason,
                      groupValue: _selectedReportReason,
                      activeColor: Colors.red,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => _selectedReportReason = val),
                    )),
                const SizedBox(height: 16),
                Text(
                  isAr ? 'تفاصيل إضافية للشكوى' : 'Additional details',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reportDetailsController,
                  maxLines: 3,
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  decoration: InputDecoration(
                    hintText: isAr ? 'اكتب التفاصيل هنا...' : 'Type details here...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDark ? Colors.white10 : Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          isAr ? 'إلغاء' : 'Cancel',
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedReportReason == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isAr ? 'يرجى اختيار سبب الإبلاغ' : 'Please select a reason'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          if (_reportDetailsController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isAr ? 'يرجى كتابة تفاصيل المشكلة' : 'Please provide problem details'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isAr ? 'تم إرسال إبلاغك بنجاح' : 'Report submitted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          isAr ? 'إرسال إبلاغ' : 'Submit Report',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_selectedRating == 0) return;
    final jobId = int.tryParse(widget.job.id);
    if (jobId == null) return;

    setState(() => _isSubmittingReview = true);
    try {
      await RatingService.instance.createRating(
        ratingValue: _selectedRating,
        comment: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
        jobId: jobId,
        raterType: 'tradesman',
      );
      _reviewController.clear();
      _selectedRating = 0;
      await _loadReviews();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).isAr
                ? 'تم إضافة تقييمك بنجاح'
                : 'Rating submitted successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).isAr
                ? 'حدث خطأ أثناء إرسال التقييم'
                : 'Failed to submit rating',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmittingReview = false);
    }
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
                title: '',
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Logo (Right)
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: job.companyLogoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image(image: getAppImageProvider(job.companyLogoUrl!)!, fit: BoxFit.cover),
                                )
                              : Icon(job.logoIcon ?? Icons.business, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 8),
                        // Text Info (Middle - Expanded to prevent overflow)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                () {
                                  String title = t.translateJobTitle(job.title);
                                  final unwanted = ['خبرة', 'مطلوب', 'محترف', 'experience', 'required', 'professional'];
                                  for (final w in unwanted) {
                                    title = title.replaceAll(RegExp(w, caseSensitive: false), '').trim();
                                  }
                                  return title.replaceAll(RegExp(r'\s+'), ' ');
                                }(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job.companyName,
                                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Rating
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '4.8',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 12),
                                  // Job Type
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      translateValue(job.type, t.isAr),
                                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Report Button (Left)
                        IconButton(
                          icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 26),
                          tooltip: t.isAr ? 'إبلاغ' : 'Report',
                          onPressed: () => _showReportBottomSheet(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Description Card
              _buildSectionCard(
                context,
                title: t.isAr ? 'الوصف' : 'Description',
                child: Text(
                  job.description.isNotEmpty 
                      ? job.description 
                      : (t.isAr ? 'لا يوجد وصف متاح لهذه الوظيفة حالياً.' : 'No description available for this job.'),
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.6),
                  textAlign: t.isAr ? TextAlign.right : TextAlign.left,
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
                    _buildInfoRow(Icons.calendar_today_outlined, 'تاريخ النشر', publishDate),
                    _buildInfoRow(Icons.location_on_outlined, 'مكان العمل', translateValue(job.location, t.isAr)),
                    _buildInfoRow(Icons.calendar_month_outlined, 'أيام العمل', t.isAr ? '6 أيام في الأسبوع' : '6 Days / Week'),
                    _buildInfoRow(Icons.attach_money, 'الراتب', job.salaryRange),
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
                  children: (job.tags.isNotEmpty ? job.tags : job.qualifications).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        skill.trim(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Work Field Card
              _buildSectionCard(
                context,
                title: t.isAr ? 'مجال العمل' : 'Work Field',
                child: Text(
                  translateValue(job.category, t.isAr),
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: t.isAr ? TextAlign.right : TextAlign.left,
                ),
              ),

              const SizedBox(height: 16),

              // Job Type Card
              _buildSectionCard(
                context,
                title: t.isAr ? 'نوع الوظيفة' : 'Job Type',
                child: Text(
                  translateValue(job.type, t.isAr),
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: t.isAr ? TextAlign.right : TextAlign.left,
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
                        Text(
                          t.isAr ? 'اضف تقييمك' : 'Add Rating', 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (store.applications.any((app) => app.jobId == job.id)) ...[
                      _buildRatingStars(),
                      const SizedBox(height: 12),
                      _buildReviewInput(),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          t.isAr 
                              ? 'لا يمكنك تقييم هذا العمل إلا بعد التقديم عليه' 
                              : 'You can only rate this job after applying for it.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.orangeAccent, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      t.isAr ? 'التعليقات' : 'Comments', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    const SizedBox(height: 10),
                    if (_isLoadingReviews)
                      const Center(child: CircularProgressIndicator())
                    else if (_customerReviews.isEmpty)
                      Text(
                        t.isAr ? 'لا توجد تعليقات بعد' : 'No comments yet',
                        style: const TextStyle(color: Colors.white70),
                      )
                    else
                      ..._customerReviews.map(
                        (review) => _buildReviewItem({
                          'name': RatingUtils.authorName(review),
                          'rating': RatingUtils.value(review).round(),
                          'comment': RatingUtils.comment(review),
                        }),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              AppButton(
                label: job.acceptedCount < job.capacity
                    ? t.tr(en: 'Apply Now', ar: 'قدّم الآن')
                    : t.tr(en: 'Job Closed', ar: 'الوظيفة مغلقة'),
                backgroundColor: job.acceptedCount < job.capacity ? const Color(0xFF142C66) : Colors.grey,
                onPressed: job.acceptedCount < job.capacity
                    ? () => Navigator.push(context, MaterialPageRoute(builder: (c) => TradesmanApplyJobScreen(job: job)))
                    : null,
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required Widget child}) {
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
          if (title.isNotEmpty) ...[
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 14),
          ],
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
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCapacityBar(BuildContext context, RecruitmentJob job) {
    final ratio = job.capacity == 0 ? 0.0 : (job.acceptedCount / job.capacity).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'المقبولين ${job.acceptedCount} من ${job.capacity}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFFF7A2A)),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(ratio >= 1.0 ? Colors.greenAccent : const Color(0xFFFF7A2A)),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _buildRatingBox() {
    final average = RatingUtils.average(_customerReviews);
    final label = _customerReviews.isEmpty ? '--' : average.toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
          icon: Icon(index < _selectedRating ? Icons.star : Icons.star_border, color: Colors.amber, size: 28),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: _isSubmittingReview
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              )
            : IconButton(
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
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: List.generate(5, (i) => Icon(Icons.star, size: 12, color: i < review['rating'] ? Colors.amber : Colors.white24))),
              Text(review['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(review['comment'], style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
