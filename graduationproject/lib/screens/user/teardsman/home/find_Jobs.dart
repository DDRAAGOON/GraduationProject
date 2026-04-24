import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import '../../../../../shared/state/recruitment_sync_store.dart';
import '../post/post_job.dart';
import '../setting/settings.dart';
import 'tradesman_apply_job_screen.dart';
import 'tradesman_job_details_screen.dart';

class FindJobs extends StatefulWidget {
  const FindJobs({super.key});

  @override
  State<FindJobs> createState() => _FindJobsState();
}

class _FindJobsState extends State<FindJobs> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = "Cairo";

  final List<String> _egyptGovernorates = [
    "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", 
    "Gharbia", "Ismailia", "Monufia", "Minya", "Qalyubia", "New Valley", 
    "Sharqia", "Suez", "Aswan", "Assiut", "Beni Suef", "Port Said", 
    "Damietta", "South Sinai", "Kafr El Sheikh", "Matrouh", "Luxor", "Qena", "Sohag", "North Sinai"
  ];

  void _showLocationPicker(AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(t.tr(en: "Select Governorate", ar: "اختر المحافظة"), style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _egyptGovernorates.length + 1,
                itemBuilder: (context, index) {
                  final loc = index == 0 ? (t.isAr ? "الكل" : "All") : _egyptGovernorates[index - 1];
                  return ListTile(
                    title: Text(loc, style: const TextStyle(color: Colors.black87)),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/company/logo/logo.png',
          height: 150,
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        actions: [
          _buildIconButton(Icons.add_circle_outline, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PostJob()));
          }),
          const SizedBox(width: 8),
          _buildIconButton(Icons.settings_outlined, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
          }),
          const SizedBox(width: 24),
        ],
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final jobs = store.filteredJobs.where((j) => j.category == 'Tradesman').toList();
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey, size: 20),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => store.updateFilters(searchQuery: val),
                            style: const TextStyle(color: Colors.black87, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: t.tr(en: "Search jobs", ar: "البحث عن وظائف"),
                              hintStyle: const TextStyle(color: Colors.black38),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                        Container(height: 24, width: 1, color: Colors.grey.withOpacity(0.3)),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _showLocationPicker(t),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.grey, size: 18),
                              const SizedBox(width: 4),
                              Text(_selectedLocation, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: t.tr(en: "All ", ar: "جميع "), style: const TextStyle(color: Colors.black87)),
                        TextSpan(text: t.job, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  jobs.isEmpty 
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(t.tr(en: 'No jobs found', ar: 'لا توجد وظائف'), style: const TextStyle(color: Colors.black54)),
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
            ),
          );
        }
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }

  Widget _buildJobCard(RecruitmentJob job, AppLocalizations t) {
    final store = RecruitmentSyncStore.instance;
    final bool isSaved = store.savedJobIds.contains(job.id);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
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
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(job.logoIcon ?? Icons.work_outline, color: Colors.black54, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    job.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.business, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.companyName, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.location, style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: job.tags.map((String tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5F1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF7A2A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TradesmanJobDetailsScreen(job: job),
                            ),
                          );
                        },
                        child: Text(
                          t.tr(en: 'View Details', ar: 'عرض التفاصيل'),
                          style: const TextStyle(color: Color(0xFFFF7A2A), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () => store.toggleSaveJob(job.id),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TradesmanApplyJobScreen(job: job),
                        ),
                      );
                    },
                    child: Text(
                      t.tr(en: 'Apply Now', ar: 'قدّم الآن'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
