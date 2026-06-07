import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
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

  final List<String> _egyptGovernorates = [
    "Cairo",
    "Giza",
    "Alexandria",
    "Dakahlia",
    "Red Sea",
    "Beheira",
    "Fayoum",
    "Gharbia",
    "Ismailia",
    "Monufia",
    "Minya",
    "Qalyubia",
    "New Valley",
    "Sharqia",
    "Suez",
    "Aswan",
    "Assiut",
    "Beni Suef",
    "Port Said",
    "Damietta",
    "South Sinai",
    "Kafr El Sheikh",
    "Matrouh",
    "Luxor",
    "Qena",
    "Sohag",
    "North Sinai",
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                t.tr(en: "Select Governorate", ar: "اختر المحافظة"),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _egyptGovernorates.length + 1,
                itemBuilder: (context, index) {
                  final loc = index == 0
                      ? "All"
                      : _egyptGovernorates[index - 1];
                  final displayText = index == 0
                      ? (t.isAr ? "الكل" : "All")
                      : t.translateLocation(loc);
                  return ListTile(
                    title: Text(
                      displayText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLocation = loc;
                        RecruitmentSyncStore.instance.updateFilters(
                          location: loc,
                        );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final jobs = store.filteredJobs
            .where(
              (j) =>
                  j.category.toLowerCase() == 'tradesman' ||
                  j.category.toLowerCase() == 'service',
            )
            .toList();
        final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner with search and text
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: const BoxDecoration(
                          color: Color(0xFF213E75),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ابحث عن اعمال',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'اكتشف فرص العمل المتاحة في مجالك وقدّم خدماتك.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.search,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      size: 22,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (val) => store.updateFilters(
                                          searchQuery: val,
                                        ),
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontSize: 14,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'ابحث عن وظيفة أو مجال...',
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 13,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 28,
                                      width: 1,
                                      color: Colors.grey.withOpacity(0.18),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _showLocationPicker(t),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _selectedLocation == "All"
                                                ? (t.isAr ? "الكل" : "All")
                                                : t.translateLocation(
                                                    _selectedLocation,
                                                  ),
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.grey.shade500,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'عرض وظيفة صنايعي',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildJobCard(
                          RecruitmentJob(
                            id: 'sample-tradesman-job',
                            title: 'سباك محترف',
                            companyName: 'شركة الصيانة الذكية',
                            location: 'القاهرة',
                            salaryRange: '3000-5000 ج.م',
                            type: 'دوام كامل',
                            status: 'Open',
                            category: 'tradesman',
                            publishedAt: DateTime.now(),
                            description:
                                'نبحث عن سباك ذو مهارة عالية للعمل على مشاريع الصيانة المنزلية والتجارية.',
                            responsibilities: const [
                              'تنفيذ أعمال السباكة المختلفة',
                              'التعامل مع العملاء بحرفية',
                            ],
                            qualifications: const [
                              'خبرة 3 سنوات على الأقل',
                              'معرفة بأحدث أدوات السباكة',
                            ],
                            benefits: const ['راتب تنافسي', 'فرص تدريب وتطوير'],
                            acceptedCount: 12,
                            capacity: 20,
                            logoIcon: Icons.plumbing,
                            specialTag: 'مميز',
                          ),
                          t,
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(height: 20),
                        jobs.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Text(
                                    t.tr(
                                      en: 'No jobs found',
                                      ar: 'لا توجد وظائف',
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.54),
                                    ),
                                  ),
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
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return Colors.green;
      case 'part-time':
        return Colors.blue;
      case 'remote':
        return Colors.purple;
      case 'freelance':
        return Colors.teal;
      case 'one-time':
        return Colors.amber;
      case 'internship':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Widget _buildJobCard(RecruitmentJob job, AppLocalizations t) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return InkWell(
      onTap: job.acceptedCount < job.capacity
          ? () {
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradesmanJobDetailsScreen(job: job),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: const Color(0xFF213E75),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
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
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      job.logoIcon ?? Icons.work_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.translateJobTitle(job.title),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.business,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    t.translateCompanyName(job.companyName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.tr(
                          en: '${job.acceptedCount} of ${job.capacity} hired',
                          ar: 'المقبولين ${job.acceptedCount} من ${job.capacity}',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '${((job.acceptedCount / job.capacity) * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: job.acceptedCount >= job.capacity
                              ? Colors.greenAccent
                              : const Color(0xFFFF7A2A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (job.acceptedCount / job.capacity).clamp(0.0, 1.0),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      color: job.acceptedCount >= job.capacity
                          ? Colors.greenAccent
                          : const Color(0xFFFF7A2A),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: job.acceptedCount < job.capacity
                      ? (isAr ? 'قدّم الآن' : 'Apply Now')
                      : (isAr ? 'الوظيفة مغلقة' : 'Job Closed'),
                  backgroundColor: job.acceptedCount < job.capacity
                      ? const Color(0xFF142C66)
                      : Colors.grey.shade600,
                  onPressed: job.acceptedCount < job.capacity
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TradesmanApplyJobScreen(job: job),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
