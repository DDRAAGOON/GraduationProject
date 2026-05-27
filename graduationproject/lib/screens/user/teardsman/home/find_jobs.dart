import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
import '../post/post_job.dart';
import 'tradesman_apply_job_screen.dart';
import 'tradesman_job_details_screen.dart';

class FindJobs extends StatefulWidget {
  const FindJobs({super.key});

  @override
  State<FindJobs> createState() => _FindJobsState();
}

class _FindJobsState extends State<FindJobs> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = "All";

  final List<String> _governorates = [
    "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", 
    "Gharbia", "Ismailia", "Monufia", "Minya", "Qalyubia", "New Valley", 
    "Sharqia", "Suez", "Aswan", "Assiut", "Beni Suef", "Port Said", 
    "Damietta", "South Sinai", "Kafr El Sheikh", "Matrouh", "Luxor", "Qena", "Sohag", "North Sinai"
  ];

  void _showLocationPicker(AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(t.tr(en: "Select Governorate", ar: "اختر المحافظة"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _governorates.length + 1,
                itemBuilder: (context, index) {
                  final loc = index == 0 ? "All" : _governorates[index - 1];
                  final displayText = index == 0 ? (t.isAr ? "الكل" : "All") : t.translateLocation(loc);
                  return ListTile(
                    title: Text(displayText, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    onTap: () {
                      setState(() {
                        _selectedLocation = loc;
                        RecruitmentSyncStore.instance.updateFilters(location: loc);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Builder(
              builder: (context) {
                final jobs = store.filteredJobs.where((j) => j.category.toLowerCase() == 'tradesman' || j.category.toLowerCase() == 'service').toList();
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Header with Image and Search Bar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: const DecorationImage(
                            image: AssetImage('assets/tradesman/Screenshot 2026-05-27 032314.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.tr(en: "Search for jobs", ar: "ابحث عن وظائف"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.tr(
                                en: "Discover thousands of job opportunities and start your career",
                                ar: "اكتشف الاف الفرص الوظيفيه و ابدا مسيرتك المهنيه",
                              ),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.search, color: Colors.grey, size: 20)),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (val) => store.updateFilters(searchQuery: val),
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                                      decoration: InputDecoration(
                                        hintText: t.tr(en: "Search jobs", ar: "البحث عن وظائف"),
                                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      ),
                                    ),
                                  ),
                                  Container(height: 24, width: 1, color: Theme.of(context).dividerColor.withOpacity(0.2)),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _showLocationPicker(t),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.primary, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          _selectedLocation == "All" ? (t.isAr ? "الكل" : "All") : t.translateLocation(_selectedLocation), 
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w500)
                                        ),
                                        Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38), size: 18),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF7A2A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.search, color: Colors.white, size: 20),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                              children: [
                                TextSpan(text: t.tr(en: "All ", ar: "جميع ")),
                                TextSpan(text: t.job, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary, size: 20),
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      jobs.isEmpty 
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(t.tr(en: 'No jobs found', ar: 'لا توجد وظائف'), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54))),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            return _buildJobCard(jobs[index], t);
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time': return Colors.green;
      case 'part-time': return Colors.blue;
      case 'remote': return Colors.purple;
      case 'freelance': return Colors.teal;
      case 'one-time': return Colors.amber;
      case 'internship': return Colors.indigo;
      default: return Colors.grey;
    }
  }

  Widget _buildJobCard(RecruitmentJob job, AppLocalizations t) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final applicantCount = store.applications.where((a) => a.jobId == job.id).length;

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(job.logoIcon ?? Icons.work_outline, color: Theme.of(context).colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.translateJobTitle(job.title),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.business, size: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
                const SizedBox(width: 4),
                Text(t.translateCompanyName(job.companyName), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.type.split(RegExp(r'[•,;]')).map((tStr) {
                final type = tStr.trim();
                if (type.isEmpty) return const SizedBox.shrink();
                final color = _getJobTypeColor(type);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    t.translateJobType(type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.people_outline, size: 16, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  t.tr(en: 'Applicants: $applicantCount', ar: 'عدد المتقدمين: $applicantCount'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: isAr ? 'قدّم الآن' : 'Apply Now', 
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
            ),
          ],
        ),
      ),
    );
  }
}
