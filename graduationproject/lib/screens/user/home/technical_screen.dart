import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../constants/app_images.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/utils/image_helper.dart';
import '../notifications/notifications_screen.dart';
import '../settings/setting_screen.dart';
import '../jobs/recruitment_job_application_screen.dart';
import '../../../shared/l10n/app_localizations.dart';

class TechnicalScreen extends StatefulWidget {
  const TechnicalScreen({super.key});

  @override
  State<TechnicalScreen> createState() => _TechnicalScreenState();
}

class _TechnicalScreenState extends State<TechnicalScreen> {
  bool _isEmploymentExpanded = false;
  bool _isSalaryExpanded = false;

  String _selectedCategory = "technical";
  String _selectedLocation = "Cairo";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _egyptGovernorates = [
    "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum",
    "Gharbia", "Ismailia", "Monufia", "Minya", "Qalyubia", "New Valley",
    "Sharqia", "Suez", "Aswan", "Assiut", "Beni Suef", "Port Said",
    "Damietta", "South Sinai", "Kafr El Sheikh", "Matrouh", "Luxor", "Qena", "Sohag", "North Sinai"
  ];

  final Map<String, bool> _selectedFilters = {
    "Full-time (3)": true, "Part-Time (5)": false, "Remote (2)": false,
    "Internship (24)": false, "Contract (3)": false, "Design (24)": true,
    "Sales (3)": false, "Marketing (3)": true, "Business (3)": false,
    "Human Resource (6)": false, "Entry Level (57)": false, "Mid Level (3)": false,
    "Senior Level (5)": true, "Director (12)": false, "VP or Above (8)": false,
    "\$700 - \$1000 (4)": false, "\$1000 - \$1500 (8)": false,
    "\$1500 - \$2000 (10)": false, "\$3000 or above (4)": false,
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    RecruitmentSyncService.instance.startPolling();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProfileImage(BuildContext context, ImageProvider? provider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            if (provider != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(image: provider, fit: BoxFit.contain),
              )
            else
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person, size: 120, color: Colors.grey),
              ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 15,
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
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
          backgroundColor: const Color(0xFFF9F9F9),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(store),
                  const SizedBox(height: 25),
                  _buildSearchSection(),
                  const SizedBox(height: 15),
                  Text("${t.tr(en: "Popular", ar: "شائع")} : UI Designer, UX Researcher, Android",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11)),
                  const SizedBox(height: 25),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildFilterSection(
                          title: "Type of Employment",
                          isExpanded: _isEmploymentExpanded,
                          onToggle: () => setState(() => _isEmploymentExpanded = !_isEmploymentExpanded),
                          items: ["Full-time (3)", "Part-Time (5)", "Remote (2)", "Internship (24)", "Contract (3)"],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildFilterSection(
                          title: "Salary Range",
                          isExpanded: _isSalaryExpanded,
                          onToggle: () => setState(() => _isSalaryExpanded = !_isSalaryExpanded),
                          items: ["\$700 - \$1000 (4)", "\$1000 - \$1500 (8)", "\$1500 - \$2000 (10)", "\$3000 or above (4)"],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
                  const SizedBox(height: 25),

                  // Explore By Categories Header
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: t.tr(en: "Explore By ", ar: "استكشف حسب "), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                        TextSpan(text: t.categoryLabel, style: const TextStyle(color: Color(0xFF578BC7))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryTabs(),

                  const SizedBox(height: 35),

                  // Exceptional Jobs Section (Matching the Image)
                  _buildExceptionalJobsSection(t, store),

                  const SizedBox(height: 35),
                  _buildDynamicJobSection(t),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(RecruitmentSyncStore store) {
    final profileImageProvider = getAppImageProvider(store.profileImage);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _showProfileImage(context, profileImageProvider),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).cardColor,
            backgroundImage: profileImageProvider,
            child: store.profileImage == null ? const Icon(Icons.person, size: 22) : null,
          ),
        ),
        Row(
          children: [
            _buildTopIconButton(Icons.notifications_none,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()))),
            const SizedBox(width: 12),
            _buildTopIconButton(Icons.settings_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()))),
          ],
        ),
      ],
    );
  }

  Widget _buildTopIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF0D2D4D)
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 22),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 18),
          Expanded(
              child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).tr(en: "Search jobs", ar: "البحث عن وظائف"),
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                      border: InputBorder.none
                  )
              )
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF4A6ED1), borderRadius: BorderRadius.circular(20)),
              child: Text(AppLocalizations.of(context).tr(en: "Search", ar: "بحث"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final t = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: _buildTabItem(t.tr(en: "Technical", ar: "تقني"), "technical", Bootstrap.laptop, const Color(0xFF6C63FF))),
        const SizedBox(width: 10),
        Expanded(child: _buildTabItem(t.tr(en: "Non-Technical", ar: "إداري"), "non-technical", FontAwesome.user_tie_solid, const Color(0xFF4CAF50))),
        const SizedBox(width: 10),
        Expanded(child: _buildTabItem(t.tr(en: "Services", ar: "خدمات"), "service", Bootstrap.bell, const Color(0xFFFF9800))),
      ],
    );
  }

  Widget _buildTabItem(String label, String value, IconData icon, Color activeColor) {
    bool isSelected = _selectedCategory == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? Colors.transparent : Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildExceptionalJobsSection(AppLocalizations t, RecruitmentSyncStore store) {
    final nexoraJobs = store.jobs.where((j) => j.companyName == "Nexora Solutions").toList();
    final jobsToShow = nexoraJobs.isEmpty ? store.jobs.take(4).toList() : nexoraJobs;

    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.tr(en: "Exceptional Jobs", ar: "استثنائية فرص العمل"),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      "عرض كل الوظائف",
                      style: TextStyle(color: Color(0xFF5E5EDD), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Text(" — ", style: TextStyle(color: Color(0xFF5E5EDD), fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 270,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: jobsToShow.length,
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemBuilder: (context, index) {
                return _buildExceptionalJobCard(jobsToShow[index], index == 0);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExceptionalJobCard(RecruitmentJob job, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecruitmentJobApplicationScreen(job: job)));
      },
      child: Container(
        width: 270,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    job.type.contains("/") ? job.type : (job.id.contains("remote") ? "عن بعد" : job.type),
                    style: const TextStyle(color: Color(0xFF6C63FF), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.grid_view_rounded, color: Color(0xFF2D4990), size: 40),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              job.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.3, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              "${job.companyName} • عن بعد",
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job.specialTag ?? "عام",
                  style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({required String title, required bool isExpanded, required VoidCallback onToggle, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
              Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface, size: 18),
            ],
          ),
        ),
        if (isExpanded)
          Column(
            children: [
              const SizedBox(height: 10),
              ...items.map((item) => _buildCheckbox(item)),
            ],
          ),
      ],
    );
  }

  Widget _buildCheckbox(String label) {
    bool isSelected = _selectedFilters[label] ?? false;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilters[label] = !isSelected),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Container(
              width: 16, height: 16,
              decoration: BoxDecoration(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(4), border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38))),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 11), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicJobSection(AppLocalizations t) {
    final store = RecruitmentSyncStore.instance;
    final String query = _searchController.text.toLowerCase();

    final List<RecruitmentJob> categoryJobs = store.jobs
        .where((job) => job.companyName != "Nexora Solutions")
        .where((job) => job.category.toLowerCase() == _selectedCategory.toLowerCase() &&
        job.title.toLowerCase().contains(query))
        .toList();

    if (categoryJobs.isEmpty) return const SizedBox();

    return Column(
      children: [
        _buildSectionHeader("All jobs"),
        const SizedBox(height: 15),
        ...categoryJobs.map((job) => _buildJobCard(job)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final t = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: title.split(' ')[0]),
              const TextSpan(text: " "),
              TextSpan(text: title.split(' ')[1], style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
        Row(
          children: [
            Text(t.tr(en: "Show all jobs", ar: "عرض الكل"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 12)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildJobCard(RecruitmentJob job) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage(AppImages.companyProfile1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(job.companyName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w500)),
                    Text(" • ", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38))),
                    Text(job.location, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecruitmentJobApplicationScreen(job: job)));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFF4A6ED1), borderRadius: BorderRadius.circular(20)),
              child: Text(t.tr(en: "Apply", ar: "تقديم"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, {bool isHighlighted = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlighted ? Theme.of(context).cardColor : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isHighlighted ? Colors.orange.withValues(alpha: 0.5) : Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(color: isHighlighted ? Colors.orange : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 10),
      ),
    );
  }
}
