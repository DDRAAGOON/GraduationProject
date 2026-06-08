import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/services/rating_service.dart';
import '../../../shared/utils/rating_utils.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({super.key, required this.company});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _userRating = 0;
  List<Map<String, dynamic>> _ratings = [];
  bool _isLoadingRatings = true;
  bool _isSubmitting = false;

  int? get _companyId {
    final raw = widget.company['id'] ?? widget.company['_id'];
    if (raw == null) return null;
    return int.tryParse(raw.toString());
  }

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    final companyId = _companyId;
    if (companyId == null) {
      if (mounted) setState(() => _isLoadingRatings = false);
      return;
    }
    setState(() => _isLoadingRatings = true);
    final ratings = await RatingService.instance.getCompanyRatings(companyId);
    if (!mounted) return;
    setState(() {
      _ratings = ratings;
      _isLoadingRatings = false;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (_userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr
                ? 'يرجى اختيار التقييم بالنجوم أولاً'
                : 'Please select a star rating first',
          ),
        ),
      );
      return;
    }

    final companyId = _companyId;
    if (companyId == null) return;

    setState(() => _isSubmitting = true);
    try {
      await RatingService.instance.createRating(
        ratingValue: _userRating,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
        companyId: companyId,
        raterType: 'user',
      );
      _commentController.clear();
      _userRating = 0;
      await _loadRatings();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'تم إضافة تقييمك بنجاح' : 'Your rating was submitted',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAr ? 'حدث خطأ أثناء إرسال التقييم' : 'Failed to submit rating',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color textColor = isDark ? const Color(0xFFD9D9D9) : Colors.black;

    final name =
        widget.company['name']?.toString() ??
        widget.company['companyName']?.toString() ??
        'Company';
    final companyJobs = store.jobs
        .where(
          (job) =>
              job.companyName.trim().toLowerCase() == name.trim().toLowerCase(),
        )
        .toList();

    final industry =
        widget.company['industry']?.toString() ??
        widget.company['category']?.toString() ??
        '---';
    final location =
        widget.company['location']?.toString() ??
        widget.company['address']?.toString() ??
        (isAr ? 'القاهرة، مصر' : 'Cairo, Egypt');
    final employees =
        widget.company['employees']?.toString() ??
        widget.company['employeesCount']?.toString() ??
        '50 - 200';
    final founded =
        widget.company['founded']?.toString() ??
        widget.company['foundedYear']?.toString() ??
        '2015';

    final descriptionEn =
        widget.company['aboutEn']?.toString() ??
        widget.company['description']?.toString() ??
        'A leading company providing an amazing work environment.';
    final descriptionAr =
        widget.company['aboutAr']?.toString() ??
        widget.company['description']?.toString() ??
        'شركة رائدة توفر بيئة عمل ممتازة.';
    final desc = isAr ? descriptionAr : descriptionEn;

    List<dynamic> extractList(dynamic value) {
      if (value is List) return value;
      if (value is Map) return [value];
      return [];
    }

    final benefitsList = extractList(widget.company['benefits']);
    final socialLinksList = extractList(widget.company['socialLinks']);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF001E3A)
          : const Color(0xFFF8FBF4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.tr(en: 'Company Profile', ar: 'ملف الشركة'),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context, isDark, isAr, textColor),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Company Basic Info Rows
                  _buildSectionTitle(
                    t.tr(en: 'Company Information', ar: 'معلومات الشركة'),
                    textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    isDark,
                    Column(
                      children: [
                        _buildDetailRow(
                          Icons.category_outlined,
                          t.tr(en: 'Industry', ar: 'مجال العمل'),
                          industry,
                          isDark,
                          textColor,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          Icons.location_on_outlined,
                          t.tr(en: 'Location', ar: 'الموقع'),
                          location,
                          isDark,
                          textColor,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          Icons.groups_outlined,
                          t.tr(en: 'Employees', ar: 'عدد الموظفين'),
                          employees,
                          isDark,
                          textColor,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          Icons.event_available_outlined,
                          t.tr(en: 'Founded', ar: 'تاريخ التأسيس'),
                          founded,
                          isDark,
                          textColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),

                  // 2. Reviews & Feedback (Input + List)
                  _buildSectionTitle(
                    t.tr(en: 'Reviews & Feedback', ar: 'التقييمات والآراء'),
                    textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    isDark,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'تقييمك:' : 'Your Rating:',
                          style: const TextStyle(
                            color: Color(0xFF142C66),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (index) => IconButton(
                                icon: Icon(
                                  index < _userRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFFF7A2A),
                                  size: 28,
                                ),
                                onPressed: () =>
                                    setState(() => _userRating = index + 1),
                                padding: const EdgeInsets.only(right: 8),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _commentController,
                          style: const TextStyle(color: Color(0xFF142C66)),
                          decoration: InputDecoration(
                            hintText: isAr
                                ? 'اكتب تعليقك هنا...'
                                : 'Write your comment...',
                            hintStyle: TextStyle(
                              color: const Color(0xFF142C66).withOpacity(0.5),
                            ),
                            suffixIcon: _isSubmitting
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: Color(0xFFFF7A2A),
                                    ),
                                    onPressed: _addComment,
                                  ),
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(color: Colors.white24),
                        if (_isLoadingRatings)
                          const Center(child: CircularProgressIndicator())
                        else if (_ratings.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              isAr ? 'لا توجد تقييمات بعد' : 'No ratings yet',
                              style: const TextStyle(color: Color(0xFF142C66)),
                            ),
                          )
                        else
                          ..._ratings.map((c) {
                              final name = RatingUtils.authorName(c);
                              final text = RatingUtils.comment(c);
                              final rating = RatingUtils.value(c).round();

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF142C66),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => Icon(
                                          Icons.star,
                                          size: 14,
                                          color: index < rating
                                              ? const Color(0xFFFF7A2A)
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  text,
                                  style: const TextStyle(
                                    color: Color(0xFF142C66),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. About Company (Description)
                  _buildSectionTitle(
                    t.tr(en: 'About Company', ar: 'عن الشركة'),
                    textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    isDark,
                    Text(
                      desc,
                      style: const TextStyle(
                        height: 1.6,
                        color: Color(0xFF142C66),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Social Media Links
                  if (socialLinksList.isNotEmpty) ...[
                    _buildSectionTitle(
                      t.tr(en: 'Social Media', ar: 'روابط التواصل'),
                      textColor,
                    ),
                    const SizedBox(height: 12),
                    _buildContentCard(
                      isDark,
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: socialLinksList.map((link) {
                          final strLink = link.toString().toLowerCase();
                          IconData icon = Icons.language;
                          Color color = Colors.blue;
                          if (strLink.contains('facebook')) {
                            icon = Icons.facebook;
                            color = Colors.indigo;
                          } else if (strLink.contains('linkedin')) {
                            icon = Icons.work;
                            color = Colors.blueAccent;
                          } else if (strLink.contains('twitter') ||
                              strLink.contains('x.com')) {
                            icon = Icons.alternate_email;
                            color = Colors.lightBlue;
                          } else if (strLink.contains('instagram')) {
                            icon = Icons.camera_alt;
                            color = Colors.pink;
                          }

                          return _buildSocialIcon(icon, color);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 5. Benefits/Perks
                  if (benefitsList.isNotEmpty) ...[
                    _buildSectionTitle(
                      t.tr(en: 'Benefits', ar: 'المميزات'),
                      textColor,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: benefitsList.map((b) {
                        if (b is Map<String, dynamic>) {
                          return _buildBenefitChip(
                            b['title']?.toString() ?? '',
                            isDark,
                          );
                        } else {
                          return _buildBenefitChip(b.toString(), isDark);
                        }
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // 6. Open Vacancies
                  _buildSectionTitle(
                    t.tr(en: 'Open Vacancies', ar: 'الوظائف المتاحة'),
                    textColor,
                  ),
                  const SizedBox(height: 16),
                  if (companyJobs.isEmpty)
                    Center(
                      child: Text(
                        t.tr(en: 'No vacancies', ar: 'لا توجد وظائف حالياً'),
                        style: TextStyle(color: textColor),
                      ),
                    )
                  else
                    ...companyJobs.map(
                      (job) => _buildJobItem(job, context, isDark),
                    ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    bool isAr,
    Color textColor,
  ) {
    const headerColor = Color(0xFF213E75);
    final name =
        widget.company['name']?.toString() ??
        widget.company['companyName']?.toString() ??
        '---';
    final industry =
        widget.company['industry']?.toString() ??
        widget.company['category']?.toString() ??
        '---';
    final logoUrl =
        widget.company['logoUrl']?.toString() ??
        widget.company['photoUrl']?.toString() ??
        widget.company['avatar']?.toString();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.15),
            backgroundImage: logoUrl != null && logoUrl.isNotEmpty
                ? NetworkImage(logoUrl)
                : null,
            child: logoUrl == null || logoUrl.isEmpty
                ? const Icon(Icons.business, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            industry,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildContentCard(bool isDark, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB5ADAD),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
    Color textColor,
  ) {
    const rowTextColor = Color(0xFF142C66);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF142C66)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: rowTextColor.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: rowTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildBenefitChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4CAF50),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildJobItem(RecruitmentJob job, BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.userJobDetails, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.work_outline, color: Colors.white70),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                job.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}
