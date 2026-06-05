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
  State<CompanyPublicProfileScreen> createState() => _CompanyPublicProfileScreenState();
}

class _CompanyPublicProfileScreenState extends State<CompanyPublicProfileScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _mockComments = [
    {'name': 'أحمد علي', 'text': 'شركة محترمة جداً وبيئة عمل ممتازة.', 'date': '2024-05-10'},
    {'name': 'سارة محمود', 'text': 'تجربة رائعة مع فريق التوظيف لديهم.', 'date': '2024-05-08'},
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
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final company = widget.company;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isAr ? 'ملف الشركة' : 'Company Profile',
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // 1. Header Card (Logo, Name, Info)
            _buildContainerCard(
              child: Column(
                children: [
                  Row(
                    textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: company.logoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image(image: getAppImageProvider(company.logoUrl)!, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.business_rounded, color: Colors.white, size: 35),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              company.name,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              company.industry,
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 10),
                  // Site, Employees, Founded Side by Side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      _buildHeaderVerticalStat(Icons.location_on_outlined, isAr ? 'الموقع' : 'Site', company.locations.isNotEmpty ? company.locations.first : 'N/A'),
                      _buildHeaderVerticalStat(Icons.people_outline, isAr ? 'الموظفين' : 'Staff', company.employee),
                      _buildHeaderVerticalStat(Icons.calendar_today_outlined, isAr ? 'التأسيس' : 'Founded', company.foundedYear.toString()),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Reviews Section
            _buildSectionTitle(isAr ? 'التعليقات والآراء' : 'Comments & Opinions', isAr, isDark),
            const SizedBox(height: 12),
            _buildContainerCard(
              child: Column(
                children: [
                  TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      hintText: isAr ? 'اكتب تعليقك هنا...' : 'Write your comment...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        onPressed: _addComment,
                        icon: const Icon(Icons.send, color: Color(0xFFFF7A2A)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _mockComments.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 20),
                    itemBuilder: (context, index) {
                      final c = _mockComments[index];
                      return Column(
                        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Text(c['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(c['date'], style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(c['text'], style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13), textAlign: isAr ? TextAlign.right : TextAlign.left),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Company About (ملف الشركة)
            _buildSectionTitle(isAr ? 'ملف الشركة' : 'Company Profile', isAr, isDark),
            const SizedBox(height: 12),
            _buildContainerCard(
              child: Text(
                isAr ? company.aboutAr : company.aboutEn,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
                textAlign: isAr ? TextAlign.right : TextAlign.left,
              ),
            ),

            const SizedBox(height: 24),

            // 4. Contact (التواصل)
            _buildSectionTitle(isAr ? 'التواصل' : 'Contact', isAr, isDark),
            const SizedBox(height: 12),
            _buildContainerCard(
              child: Column(
                children: [
                  _buildContactLink(Icons.language, isAr ? 'الموقع الإلكتروني' : 'Website', company.website, isAr),
                  if (company.website.isNotEmpty) const SizedBox(height: 10),
                  _buildContactLink(Icons.link, 'Facebook', 'facebook.com/${company.name.replaceAll(' ', '')}', isAr),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Benefits (المميزات)
            _buildSectionTitle(isAr ? 'المميزات' : 'Benefits', isAr, isDark),
            const SizedBox(height: 12),
            _buildContainerCard(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: isAr ? WrapAlignment.end : WrapAlignment.start,
                children: company.benefits.map((b) => _buildBadge(b, const Color(0xFFFF7A2A))).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // 6. Available Jobs (الوظائف المتاحة)
            _buildSectionTitle(isAr ? 'الوظائف المتاحة' : 'Available Jobs', isAr, isDark),
            const SizedBox(height: 12),
            if (company.jobs.isEmpty)
              Center(child: Text(isAr ? 'لا توجد وظائف متاحة حالياً' : 'No available jobs', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)))
            else
              ...company.jobs.map((job) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildJobCard(job, isAr),
              )),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderVerticalStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFF7A2A), size: 20),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildContainerCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF213E75),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, bool isAr, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF142C66),
          ),
        ),
      ),
    );
  }

  Widget _buildContactLink(IconData icon, String label, String url, bool isAr) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      },
      child: Row(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const Spacer(),
          const Icon(Icons.open_in_new, color: Colors.white30, size: 14),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildJobCard(RecruitmentJob job, bool isAr) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(job.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
            children: [
              _buildJobMeta(Icons.location_on_outlined, job.location),
              const SizedBox(width: 16),
              _buildJobMeta(Icons.work_outline, job.type),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isAr ? 'عرض التفاصيل' : 'View Details',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
