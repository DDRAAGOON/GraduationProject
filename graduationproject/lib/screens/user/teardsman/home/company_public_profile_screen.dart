import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../shared/utils/image_helper.dart';

class CompanyPublicProfile {
  final String name;
  final String industry;
  final String? logoUrl;
  final String aboutEn;
  final String aboutAr;
  final String website;
  final String employee;
  final String category;
  final List<String> locations;
  final List<String> techStack;
  final List<String> benefits;
  final int foundedYear;
  final List<RecruitmentJob> jobs;

  const CompanyPublicProfile({
    required this.name,
    required this.industry,
    this.logoUrl,
    required this.aboutEn,
    required this.aboutAr,
    required this.website,
    required this.employee,
    required this.category,
    required this.locations,
    required this.techStack,
    required this.benefits,
    required this.foundedYear,
    required this.jobs,
  });
}

class CompanyPublicProfileScreen extends StatefulWidget {
  final CompanyPublicProfile company;

  const CompanyPublicProfileScreen({super.key, required this.company});

  @override
  State<CompanyPublicProfileScreen> createState() =>
      _CompanyPublicProfileScreenState();
}

class _CompanyPublicProfileScreenState
    extends State<CompanyPublicProfileScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _mockComments = [
    {
      'name': 'أحمد علي',
      'text': 'شركة محترمة جداً وبيئة عمل ممتازة.',
      'date': '2024-05-10',
    },
    {
      'name': 'سارة محمود',
      'text': 'تجربة رائعة مع فريق التوظيف لديهم.',
      'date': '2024-05-08',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _mockComments.insert(0, {
        'name': RecruitmentSyncStore.instance.currentUserName,
        'text': text,
        'date': DateTime.now().toString().split(' ')[0],
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final company = widget.company;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isAr ? 'ملف الشركة' : 'Company Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section (213E75)
            _buildHeader(context, isDark, isAr),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: isAr
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // 2. Basic Info (B5ADAD)
                  _buildSectionTitle(
                    isAr ? 'معلومات الشركة' : 'Company Information',
                    isAr,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.category_outlined,
                          isAr ? 'مجال العمل' : 'Industry',
                          company.industry,
                        ),
                        const Divider(color: Colors.white24),
                        _buildDetailRow(
                          Icons.location_on_outlined,
                          isAr ? 'الموقع' : 'Location',
                          company.locations.isNotEmpty
                              ? company.locations.first
                              : 'N/A',
                        ),
                        const Divider(color: Colors.white24),
                        _buildDetailRow(
                          Icons.groups_outlined,
                          isAr ? 'عدد الموظفين' : 'Employees',
                          company.employee,
                        ),
                        const Divider(color: Colors.white24),
                        _buildDetailRow(
                          Icons.event_available_outlined,
                          isAr ? 'تاريخ التأسيس' : 'Founded',
                          company.foundedYear.toString(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Reviews (B5ADAD)
                  _buildSectionTitle(
                    isAr ? 'التقييمات والآراء' : 'Reviews & Feedback',
                    isAr,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    child: Column(
                      children: [
                        TextField(
                          controller: _commentController,
                          style: const TextStyle(
                            color: Color(0xFF142C66),
                            fontSize: 14,
                          ),
                          textAlign: isAr ? TextAlign.right : TextAlign.left,
                          decoration: InputDecoration(
                            hintText: isAr
                                ? 'اكتب تعليقك هنا...'
                                : 'Write your comment...',
                            hintStyle: TextStyle(
                              color: const Color(0xFF142C66).withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Color(0xFFFF7A2A),
                              ),
                              onPressed: _addComment,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white24),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _mockComments.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Colors.white24),
                          itemBuilder: (context, index) {
                            final c = _mockComments[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                c['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF142C66),
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                c['text'],
                                style: const TextStyle(
                                  color: Color(0xFF142C66),
                                  fontSize: 13,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. About Company (B5ADAD)
                  _buildSectionTitle(
                    isAr ? 'عن الشركة' : 'About Company',
                    isAr,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    child: Text(
                      isAr
                          ? (company.aboutAr.isNotEmpty
                                ? company.aboutAr
                                : company.aboutEn)
                          : company.aboutEn,
                      style: const TextStyle(
                        height: 1.6,
                        color: Color(0xFF142C66),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Contact (B5ADAD)
                  _buildSectionTitle(
                    isAr ? 'روابط التواصل' : 'Social Media',
                    isAr,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialIcon(
                          Icons.language,
                          Colors.blue,
                          company.website,
                        ),
                        _buildSocialIcon(
                          Icons.facebook,
                          Colors.indigo,
                          'https://facebook.com/${company.name.replaceAll(' ', '')}',
                        ),
                        _buildSocialIcon(
                          Icons.link,
                          Colors.blueAccent,
                          company.website,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6. Benefits (B5ADAD Chips)
                  _buildSectionTitle(
                    isAr ? 'المميزات' : 'Benefits',
                    isAr,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: isAr ? WrapAlignment.end : WrapAlignment.start,
                    children: company.benefits
                        .map((b) => _buildBenefitChip(b))
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  // 7. Open Vacancies (213E75 Cards)
                  _buildSectionTitle(
                    isAr ? 'الوظائف المتاحة' : 'Open Vacancies',
                    isAr,
                    isDark,
                  ),
                  const SizedBox(height: 16),
                  if (company.jobs.isEmpty)
                    Center(
                      child: Text(
                        isAr ? 'لا توجد وظائف حالياً' : 'No vacancies',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    )
                  else
                    ...company.jobs.map((job) => _buildJobItem(job, context)),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isAr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF213E75),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            child: widget.company.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: getAppImageProvider(widget.company.logoUrl)!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  )
                : const Icon(Icons.business, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            widget.company.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.company.industry,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isAr, bool isDark) {
    return Align(
      alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF142C66),
        ),
      ),
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB5ADAD),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    const rowTextColor = Color(0xFF142C66);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: rowTextColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: rowTextColor.withValues(alpha: 0.7),
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

  Widget _buildSocialIcon(IconData icon, Color color, String url) {
    return InkWell(
      onTap: () async {
        if (url.isEmpty) return;
        final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF142C66)),
      ),
    );
  }

  Widget _buildBenefitChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF142C66).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF142C66).withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF142C66),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildJobItem(RecruitmentJob job, BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('/user/jobs/details', arguments: job),
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
