import 'package:flutter/material.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../home/tabs/recruitment_ui_utils.dart';

class RecruitmentJobDetailsScreen extends StatefulWidget {
  const RecruitmentJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  State<RecruitmentJobDetailsScreen> createState() => _RecruitmentJobDetailsScreenState();
}

class _RecruitmentJobDetailsScreenState extends State<RecruitmentJobDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _reportDetailsController = TextEditingController();
  String? _selectedReportReason;
  int _userRating = 0; 
  
  final List<Map<String, dynamic>> _mockReviews = [
    {
      'userName': 'محمد',
      'rating': 5,
      'comment': 'عمل ممتاز وخدمة سريعة جدًا.',
      'date': 'منذ يومين',
    },
  ];

  bool get _hasApplied {
    final store = RecruitmentSyncStore.instance;
    return store.applications.any((a) => 
      a.jobId == widget.job.id && 
      a.userName == store.currentUserName && 
      (a.status.toLowerCase().contains('accept') || a.status.toLowerCase().contains('hire'))
    );
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
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(isAr ? 'إبلاغ عن وظيفة' : 'Report Job', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  isAr ? 'يرجى اختيار سبب الإبلاغ لمساعدتنا في تحسين جودة المحتوى.' : 'Please select a reason for reporting.',
                  textAlign: isAr ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ...reasons.map((reason) => RadioListTile<String>(
                  title: Text(reason, textAlign: isAr ? TextAlign.right : TextAlign.left, style: const TextStyle(fontSize: 14)),
                  value: reason,
                  groupValue: _selectedReportReason,
                  activeColor: Colors.red,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setModalState(() => _selectedReportReason = val),
                )),
                const SizedBox(height: 16),
                Text(isAr ? 'تفاصيل إضافية للشكوى' : 'Additional details', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                        child: Text(isAr ? 'إلغاء' : 'Cancel', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedReportReason == null || _reportDetailsController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isAr ? 'يرجى إكمال بيانات الإبلاغ' : 'Please complete report details'), backgroundColor: Colors.orange));
                            return;
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isAr ? 'تم إرسال إبلاغك بنجاح' : 'Report submitted'), backgroundColor: Colors.green));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: Text(isAr ? 'إرسال إبلاغ' : 'Submit Report', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty && _userRating > 0) {
      setState(() {
        _mockReviews.insert(0, {
          'userName': RecruitmentSyncStore.instance.currentUserName,
          'rating': _userRating,
          'comment': _commentController.text.trim(),
          'date': 'الآن',
        });
        _commentController.clear();
        _userRating = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة تقييمك بنجاح!'), backgroundColor: Colors.green));
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _reportDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(t.tr(en: 'Job Details', ar: 'تفاصيل الوظيفة')),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: RecruitmentSyncStore.instance,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // 1. Header Card
                _buildSectionCard(
                  context,
                  title: '',
                  child: Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 65, height: 65,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                        child: widget.job.companyLogoUrl != null
                            ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image(image: getAppImageProvider(widget.job.companyLogoUrl!)!, fit: BoxFit.cover))
                            : Icon(widget.job.logoIcon ?? Icons.business, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _cleanTitle(t.translateJobTitle(widget.job.title)),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 4),
                            Text(widget.job.companyName, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13), textAlign: TextAlign.right),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                const Text('4.8', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                                  child: Text(translateValue(widget.job.type, isAr), style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 26),
                        onPressed: () => _showReportBottomSheet(context),
                        padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Description Card
                _buildSectionCard(
                  context,
                  title: isAr ? 'الوصف' : 'Description',
                  child: Text(
                    widget.job.description.isNotEmpty ? widget.job.description : (isAr ? 'لا يوجد وصف متاح.' : 'No description available.'),
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.6),
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Job Details Card
                _buildSectionCard(
                  context,
                  title: isAr ? 'تفاصيل الوظيفة' : 'Job Details',
                  child: Column(
                    children: [
                      _buildSimpleCapacityBar(context, widget.job),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.calendar_today_outlined, isAr ? 'تاريخ النشر' : 'Posted Date', '${widget.job.publishedAt.year}-${widget.job.publishedAt.month.toString().padLeft(2, '0')}-${widget.job.publishedAt.day.toString().padLeft(2, '0')}'),
                      _buildInfoRow(Icons.location_on_outlined, isAr ? 'مكان العمل' : 'Location', translateValue(widget.job.location, isAr)),
                      _buildInfoRow(Icons.work_outline, isAr ? 'نوع الوظيفة' : 'Job Type', translateValue(widget.job.type, isAr)),
                      _buildInfoRow(Icons.calendar_month_outlined, isAr ? 'أيام العمل' : 'Work Days', isAr ? '6 أيام في الأسبوع' : '6 Days / Week'),
                      _buildInfoRow(Icons.attach_money, isAr ? 'الراتب' : 'Salary', widget.job.salaryRange),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Skills Card
                _buildSectionCard(
                  context,
                  title: isAr ? 'المهارات' : 'Skills',
                  child: Container(
                    width: double.infinity,
                    alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                    child: Wrap(
                      spacing: 10, runSpacing: 10,
                      children: (widget.job.tags.isNotEmpty ? widget.job.tags : widget.job.qualifications).map((skill) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                        child: Text(skill.trim(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      )).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Work Field Card
                _buildSectionCard(
                  context,
                  title: isAr ? 'مجال العمل' : 'Work Field',
                  child: Container(width: double.infinity, child: Text(translateValue(widget.job.category, isAr), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold), textAlign: isAr ? TextAlign.right : TextAlign.left)),
                ),

                const SizedBox(height: 16),

                // 6. Reviews Card
                _buildSectionCard(
                  context,
                  title: isAr ? 'التقييمات والآراء' : 'Reviews',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRatingBox(),
                          Text(isAr ? 'اضف تقييمك' : 'Add Rating', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_hasApplied) ...[
                        _buildRatingStars(),
                        const SizedBox(height: 12),
                        _buildReviewInput(),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16), width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                          child: Text(isAr ? 'لا يمكنك تقييم هذا العمل إلا بعد التقديم عليه' : 'Rate only after applying.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.orangeAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Container(width: double.infinity, child: Text(isAr ? 'التعليقات' : 'Comments', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), textAlign: isAr ? TextAlign.right : TextAlign.left)),
                      const SizedBox(height: 10),
                      ..._mockReviews.map((review) => _buildReviewItem(review, isAr)),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                AppButton(
                  label: isAr ? 'قدّم طلبك الآن' : 'Apply Now',
                  backgroundColor: const Color(0xFF142C66),
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userJobApplication, arguments: widget.job),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  String _cleanTitle(String title) {
    final unwanted = ['خبرة', 'مطلوب', 'محترف', 'experience', 'required', 'professional'];
    for (final w in unwanted) {
      title = title.replaceAll(RegExp(w, caseSensitive: false), '').trim();
    }
    return title.replaceAll(RegExp(r'\s+'), ' ');
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required Widget child}) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF213E75), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
          Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.white, size: 20)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ])),
        ],
      ),
    );
  }

  Widget _buildSimpleCapacityBar(BuildContext context, RecruitmentJob job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(t.tr(en: 'Accepted ${job.acceptedCount} of ${job.capacity}', ar: 'المقبولين ${job.acceptedCount} من ${job.capacity}'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFFF7A2A))),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: job.capacity == 0 ? 0 : (job.acceptedCount / job.capacity).clamp(0.0, 1.0),
            minHeight: 8, backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(job.acceptedCount >= job.capacity ? Colors.greenAccent : const Color(0xFFFF7A2A)),
          ),
        ),
      ],
    );
  }

  AppLocalizations get t => AppLocalizations.of(context);

  Widget _buildRatingBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Row(children: const [Icon(Icons.star, color: Colors.amber, size: 18), SizedBox(width: 4), Text('4.8', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))]),
    );
  }

  Widget _buildRatingStars() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: List.generate(5, (index) => IconButton(
      onPressed: () => setState(() => _userRating = index + 1),
      icon: Icon(index < _userRating ? Icons.star : Icons.star_border, color: Colors.amber, size: 28),
      padding: EdgeInsets.zero, constraints: const BoxConstraints(),
    )));
  }

  Widget _buildReviewInput() {
    return TextField(
      controller: _commentController, maxLines: 3, textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: t.isAr ? 'اكتب تعليقك هنا...' : 'Write your comment...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true, fillColor: Colors.black.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: IconButton(onPressed: _addComment, icon: const Icon(Icons.send, color: Colors.white, size: 20)),
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review, bool isAr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: List.generate(5, (i) => Icon(Icons.star, size: 12, color: i < review['rating'] ? Colors.amber : Colors.white24))),
              Text(review['userName'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(review['comment'], style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: isAr ? TextAlign.right : TextAlign.left),
        ],
      ),
    );
  }
}
