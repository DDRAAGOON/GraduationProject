import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/l10n/app_localizations.dart';

// Translation Helper consistent with the one in shell screen
String _translateValue(String? value, bool isAr) {
  if (value == null || value.isEmpty || !isAr) return value ?? "";
  final low = value.trim().toLowerCase();

  // Egyptian Governorates
  if (low == 'all') return 'الكل';
  if (low == 'cairo') return 'القاهرة';
  if (low == 'giza') return 'الجيزة';
  if (low == 'alexandria') return 'الإسكندرية';
  if (low == 'dakahlia') return 'الدقهلية';
  if (low == 'red sea') return 'البحر الأحمر';
  if (low == 'beheira') return 'البحيرة';
  if (low == 'fayoum') return 'الفيوم';
  if (low == 'gharbia') return 'الغربية';
  if (low == 'ismailia') return 'الإسماعيلية';
  if (low == 'monufia') return 'المنوفية';
  if (low == 'minya') return 'المنيا';
  if (low == 'qalyubia') return 'القليوبية';
  if (low == 'new valley') return 'الوادي الجديد';
  if (low == 'sharqia') return 'الشرقية';
  if (low == 'suez') return 'السويس';
  if (low == 'aswan') return 'أسوان';
  if (low == 'assiut') return 'أسيوط';
  if (low == 'beni suef') return 'بني سويف';
  if (low == 'port said') return 'بورسعيد';
  if (low == 'damietta') return 'دمياط';
  if (low == 'south sinai') return 'جنوب سيناء';
  if (low == 'kafr el sheikh') return 'كفر الشيخ';
  if (low == 'matrouh') return 'مطروح';
  if (low == 'luxor') return 'الأقصر';
  if (low == 'qena') return 'قنا';
  if (low == 'sohag') return 'سوهاج';
  if (low == 'north sinai') return 'شمال سيناء';
  if (low == 'remote') return 'عن بعد';

  // Job Types, Categories & Industries
  if (low == 'full-time' || low == 'full time') return 'دوام كامل';
  if (low == 'part-time' || low == 'part time') return 'دوام جزئي';
  if (low == 'freelance' || low == 'freelancer') return 'عمل حر';
  if (low == 'internship') return 'تدريب';
  if (low == 'one-time' || low == 'one time') return 'مرة واحدة';
  if (low == 'service' || low == 'services') return 'خدمة';
  if (low == 'technical') return 'تقني';
  if (low == 'non-technical') return 'غير تقني';
  if (low == 'general') return 'عام';

  // Job Titles
  if (low.contains('manager')) return 'مدير';
  if (low.contains('developer')) return 'مطور';
  if (low.contains('engineer')) return 'مهندس';
  if (low.contains('designer')) return 'مصمم';
  if (low.contains('accountant')) return 'محاسب';
  if (low.contains('technician')) return 'فني';
  if (low.contains('teacher')) return 'مدرس';
  if (low.contains('doctor')) return 'طبيب';
  if (low.contains('assistant')) return 'مساعد';
  if (low.contains('specialist')) return 'أخصائي';
  if (low.contains('programmer')) return 'مطور برمجيات';

  return value;
}

class RecruitmentJobDetailsScreen extends StatefulWidget {
  const RecruitmentJobDetailsScreen({super.key, required this.job});

  final RecruitmentJob job;

  @override
  State<RecruitmentJobDetailsScreen> createState() => _RecruitmentJobDetailsScreenState();
}

class _RecruitmentJobDetailsScreenState extends State<RecruitmentJobDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _userRating = 0; 
  
  final List<Map<String, dynamic>> _mockReviews = [
    {
      'userName': 'أحمد محمد',
      'rating': 5,
      'comment': 'شركة ممتازة جداً وبيئة عمل محفزة.',
      'date': 'منذ يومين',
    },
    {
      'userName': 'Sara Smith',
      'rating': 4,
      'comment': 'Good opportunities and professional management.',
      'date': '3 days ago',
    },
  ];

  bool get _hasApplied {
    return RecruitmentSyncStore.instance.applications.any((a) => a.jobId == widget.job.id);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة تقييمك بنجاح!'), backgroundColor: Colors.green),
      );
    } else if (_userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار عدد النجوم أولاً'), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.tr(en: 'Job Details', ar: 'تفاصيل الوظيفة')),
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
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    backgroundImage: widget.job.companyLogoUrl != null ? getAppImageProvider(widget.job.companyLogoUrl!) : null,
                    child: widget.job.companyLogoUrl == null
                        ? Icon(Icons.business, size: 40, color: primaryColor)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _translateValue(widget.job.title, isAr),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.job.companyName,
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
                      _buildHeaderTag(context, Icons.location_on_outlined, _translateValue(widget.job.location, isAr)),
                      _buildHeaderTag(context, Icons.work_outline, _translateValue(widget.job.type, isAr)),
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
                  // About Job Container
                  _buildSectionTitle(context, t.tr(en: 'About the Job', ar: 'عن الوظيفة'), primaryColor),
                  const SizedBox(height: 12),
                  _buildContentContainer(
                    context,
                    Column(
                      children: [
                        _buildJobInfoRow(
                          context, 
                          Icons.people_outline, 
                          t.tr(en: 'Seats (Accepted / Required)', ar: 'المقاعد (مقبول / مطلوب)'), 
                          '${widget.job.acceptedCount} / ${widget.job.capacity}', 
                          primaryColor
                        ),
                        const Divider(height: 32),
                        _buildJobInfoRow(
                          context, 
                          Icons.calendar_today_outlined, 
                          t.tr(en: 'Published Date', ar: 'تاريخ النشر'), 
                          '${widget.job.publishedAt.day}/${widget.job.publishedAt.month}/${widget.job.publishedAt.year}', 
                          primaryColor
                        ),
                        const Divider(height: 32),
                        _buildJobInfoRow(
                          context, 
                          Icons.work_outline, 
                          t.jobTypeLabel, 
                          _translateValue(widget.job.type, isAr), 
                          primaryColor
                        ),
                        const Divider(height: 32),
                        _buildJobInfoRow(
                          context, 
                          Icons.location_on_outlined, 
                          t.locationLabel, 
                          _translateValue(widget.job.location, isAr), 
                          primaryColor
                        ),
                        const Divider(height: 32),
                        _buildJobInfoRow(
                          context, 
                          Icons.payments_outlined, 
                          t.salaryLabel, 
                          widget.job.salaryRange, 
                          primaryColor
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Job Category (Field) Container
                  if (widget.job.category.isNotEmpty) ...[
                    _buildSectionTitle(context, t.tr(en: 'Job Field', ar: 'مجال العمل'), primaryColor),
                    const SizedBox(height: 12),
                    _buildContentContainer(
                      context,
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.category_outlined, color: primaryColor, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _translateValue(widget.job.category, isAr),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tags / Skills Container
                  if (widget.job.tags.isNotEmpty) ...[
                    _buildSectionTitle(context, t.requiredSkills, primaryColor),
                    const SizedBox(height: 12),
                    _buildContentContainer(
                      context,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.job.tags.map((tag) => Chip(
                          label: Text(_translateValue(tag, isAr)),
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          side: BorderSide.none,
                          labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Reviews & Feedback Section
                  _buildSectionTitle(context, t.tr(en: 'Reviews & Feedback', ar: 'التقييمات والآراء'), primaryColor),
                  const SizedBox(height: 12),
                  _buildContentContainer(
                    context,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating Summary Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(), 
                            Row(
                              children: [
                                Text(
                                  '4.8',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange[700]),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: List.generate(5, (index) => Icon(
                                    Icons.star, 
                                    color: index < 4 ? Colors.orange[700] : Colors.grey[300], 
                                    size: 20
                                  )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Rating input section - ONLY visible after application
                        if (_hasApplied) ...[
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            t.tr(en: 'Rate the company', ar: 'قيم الشركة:'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (index) => IconButton(
                              icon: Icon(
                                _userRating > index ? Icons.star : Icons.star_border,
                                color: Colors.orange[700],
                                size: 28,
                              ),
                              onPressed: () => setState(() => _userRating = index + 1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            )),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _commentController,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: t.tr(en: 'Write your experience...', ar: 'اكتب تجربتك هنا...'),
                              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send, color: primaryColor),
                                onPressed: _addComment,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                        ],

                        // List of comments (always visible)
                        ..._mockReviews.map((review) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review['userName'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    review['date'],
                                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(5, (index) => Icon(
                                  Icons.star, 
                                  size: 14, 
                                  color: index < review['rating'] ? Colors.orange[700] : Colors.grey[300],
                                )),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                review['comment'],
                                style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
                              ),
                              if (_mockReviews.last != review)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                                ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  if (widget.job.description.trim().isNotEmpty) ...[
                    _buildSectionTitle(context, t.descriptionSection, primaryColor),
                    const SizedBox(height: 8),
                    Text(
                      widget.job.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Responsibilities
                  if (widget.job.responsibilities.isNotEmpty) ...[
                    _buildSectionTitle(context, t.responsibilities, primaryColor),
                    const SizedBox(height: 12),
                    ...widget.job.responsibilities.map((item) => _buildBulletPoint(context, item, primaryColor)),
                    const SizedBox(height: 24),
                  ],

                  // Qualifications
                  if (widget.job.qualifications.isNotEmpty) ...[
                    _buildSectionTitle(context, t.qualifications, primaryColor),
                    const SizedBox(height: 12),
                    ...widget.job.qualifications.map((item) => _buildBulletPoint(context, item, primaryColor)),
                    const SizedBox(height: 24),
                  ],

                  // Benefits
                  if (widget.job.benefits.isNotEmpty) ...[
                    _buildSectionTitle(context, t.perksAndBenefits, primaryColor),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.job.benefits.map((item) => Container(
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
                    label: t.tr(en: 'Apply for this Job', ar: 'قدّم طلبك الآن'),
                    backgroundColor: const Color(0xFF4A6ED1),
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.userJobApplication,
                      arguments: widget.job,
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

  Widget _buildContentContainer(BuildContext context, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
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

  Widget _buildSectionTitle(BuildContext context, String title, Color color) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
    );
  }

  Widget _buildJobInfoRow(BuildContext context, IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), 
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )
              ),
              const SizedBox(height: 2),
              Text(
                value, 
                style: const TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: color),
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
