import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../app/router/app_router.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({super.key, required this.company});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [
    {'name': 'أحمد علي', 'text': 'بيئة عمل ممتازة جداً واحترافية عالية.'},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.insert(0, {
          'name': RecruitmentSyncStore.instance.currentUserName,
          'text': _commentController.text.trim(),
        });
        _commentController.clear();
      });
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
    
    final companyJobs = store.jobs.where((job) => 
      job.companyName.trim().toLowerCase() == (widget.company['name'] ?? '').toString().trim().toLowerCase()
    ).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.tr(en: 'Company Profile', ar: 'ملف الشركة'),
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
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
                  _buildSectionTitle(t.tr(en: 'Company Information', ar: 'معلومات الشركة'), textColor),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    isDark,
                    Column(
                      children: [
                        _buildDetailRow(Icons.category_outlined, t.tr(en: 'Industry', ar: 'مجال العمل'), widget.company['industry'] ?? '---', isDark, textColor),
                        const Divider(),
                        _buildDetailRow(Icons.location_on_outlined, t.tr(en: 'Location', ar: 'الموقع'), 'القاهرة، مصر', isDark, textColor),
                        const Divider(),
                        _buildDetailRow(Icons.groups_outlined, t.tr(en: 'Employees', ar: 'عدد الموظفين'), '50 - 200', isDark, textColor),
                        const Divider(),
                        _buildDetailRow(Icons.event_available_outlined, t.tr(en: 'Founded', ar: 'تاريخ التأسيس'), '2015', isDark, textColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Reviews & Feedback (Input + List)
                  _buildSectionTitle(t.tr(en: 'Reviews & Feedback', ar: 'التقييمات والآراء'), textColor),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    isDark,
                    Column(
                      children: [
                        TextField(
                          controller: _commentController,
                          style: const TextStyle(color: Color(0xFF142C66)),
                          decoration: InputDecoration(
                            hintText: isAr ? 'اكتب تعليقك هنا...' : 'Write your comment...',
                            hintStyle: TextStyle(color: const Color(0xFF142C66).withOpacity(0.5)),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send, color: Color(0xFFFF7A2A)),
                              onPressed: _addComment,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(color: Colors.white24),
                        ..._comments.map((c) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF142C66))),
                          subtitle: Text(c['text']!, style: const TextStyle(color: Color(0xFF142C66))),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. About Company (Description)
                  _buildSectionTitle(t.tr(en: 'About Company', ar: 'عن الشركة'), textColor),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    isDark,
                    Text(
                      widget.company['description'] ?? '---',
                      style: const TextStyle(height: 1.6, color: Color(0xFF142C66), fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Social Media Links
                  _buildSectionTitle(t.tr(en: 'Social Media', ar: 'روابط التواصل'), textColor),
                  const SizedBox(height: 12),
                  _buildContentCard(
                    isDark,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialIcon(Icons.language, Colors.blue),
                        _buildSocialIcon(Icons.facebook, Colors.indigo),
                        _buildSocialIcon(Icons.link, Colors.blueAccent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Benefits/Perks
                  _buildSectionTitle(t.tr(en: 'Benefits', ar: 'المميزات'), textColor),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildBenefitChip(t.tr(en: 'Health Insurance', ar: 'تأمين صحي'), isDark),
                      _buildBenefitChip(t.tr(en: 'Flexible Hours', ar: 'ساعات مرنة'), isDark),
                      _buildBenefitChip(t.tr(en: 'Transportation', ar: 'بدل انتقال'), isDark),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 6. Open Vacancies
                  _buildSectionTitle(t.tr(en: 'Open Vacancies', ar: 'الوظائف المتاحة'), textColor),
                  const SizedBox(height: 16),
                  if (companyJobs.isEmpty)
                    Center(child: Text(t.tr(en: 'No vacancies', ar: 'لا توجد وظائف حالياً'), style: TextStyle(color: textColor)))
                  else
                    ...companyJobs.map((job) => _buildJobItem(job, context, isDark)),
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isAr, Color textColor) {
    const headerColor = Color(0xFF213E75);
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
            child: const Icon(Icons.business, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            widget.company['name'] ?? '---',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            widget.company['industry'] ?? '---',
            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
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
        color: textColor
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

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark, Color textColor) {
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
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
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
      child: Text(label, style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildJobItem(RecruitmentJob job, BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.userJobDetails, arguments: job),
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
            Expanded(child: Text(job.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}


