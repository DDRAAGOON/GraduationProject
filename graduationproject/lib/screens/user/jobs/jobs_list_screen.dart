import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Top Bar Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTopIconButton(Icons.add),
                  const SizedBox(width: 12),
                  _buildTopIconButton(Icons.notifications_none, hasBadge: true),
                  const SizedBox(width: 12),
                  _buildTopIconButton(Icons.settings_outlined),
                ],
              ),
              const SizedBox(height: 20),

              // Search Section
              _buildSearchSection(t),
              const SizedBox(height: 15),

              // Popular Tags
              Text(
                "${t.tr(en: "Popular", ar: "شائع")} : UI Designer, UX Researcher, Android, Admin",
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11),
              ),
              const SizedBox(height: 25),

              // Filters Section
              _buildFiltersGrid(),
              const SizedBox(height: 30),
              Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
              const SizedBox(height: 25),

              // All Jobs Header
              _buildJobListHeader(t),
              const SizedBox(height: 20),

              // Job List
              _buildJobCard(
                title: "Social Media Assistant",
                company: "Nomad",
                location: "Paris, France",
                image: AppImages.companyLogo,
                applied: 4,
                capacity: 10,
              ),
              _buildJobCard(
                title: "Interactive Developer",
                company: "Terraform",
                location: "Hamburg, Germany",
                image: AppImages.companyLogo,
                applied: 8,
                capacity: 12,
              ),
              _buildJobCard(
                title: "Brand Designer",
                company: "Dropbox",
                location: "San Fransisco, USA",
                image: AppImages.companyLogo,
                applied: 2,
                capacity: 10,
              ),
              _buildJobCard(
                title: "Email Marketing",
                company: "Revolut",
                location: "Madrid, Spain",
                applied: 0,
                capacity: 10,
              ),

              const SizedBox(height: 20),
              // Pagination
              _buildPagination(),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIconButton(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF0D2D4D) 
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 22),
        ),
        if (hasBadge)
          Positioned(
            right: 12,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchSection(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white.withValues(alpha: 0.05) 
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.white54, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
              decoration: InputDecoration(
                hintText: t.tr(en: "Job title or keyword", ar: "عنوان الوظيفة أو كلمة مفتاحية"),
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(height: 20, width: 1, color: Colors.white24),
          const SizedBox(width: 12),
          Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 18),
          const SizedBox(width: 4),
          Text("Florence, Italy", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12)),
          Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 18),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t.tr(en: "Search", ar: "بحث"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFilterColumn("Type of Employment", [
                _buildCheckbox("Full-time (3)", true),
                _buildCheckbox("Part-Time (5)", false),
                _buildCheckbox("Remote (2)", false),
                _buildCheckbox("Internship (24)", false),
                _buildCheckbox("Contract (3)", false),
              ]),
            ),
            Expanded(
              child: _buildFilterColumn("Type of Employment", [
                _buildCheckbox("Design (24)", true),
                _buildCheckbox("Sales (3)", false),
                _buildCheckbox("Marketing (3)", true),
                _buildCheckbox("Business (3)", false),
                _buildCheckbox("Human Resource (6)", false),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFilterColumn("Type of Employment", [
                _buildCheckbox("Entry Level (57)", false),
                _buildCheckbox("Mid Level (3)", false),
                _buildCheckbox("Senior Level (5)", true),
                _buildCheckbox("Director (12)", false),
                _buildCheckbox("VP or Above (8)", false),
              ]),
            ),
            Expanded(
              child: _buildFilterColumn("Type of Employment", [
                _buildCheckbox("\$700 - \$1000 (4)", false),
                _buildCheckbox("\$100 - \$1500 (8)", false),
                _buildCheckbox("Senior Level (5)", true),
                _buildCheckbox("\$1500 - \$2000 (10)", false),
                _buildCheckbox("\$3000 or above (4)", false),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterColumn(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 13)),
            Icon(Icons.keyboard_arrow_up, color: Theme.of(context).colorScheme.onSurface, size: 18),
          ],
        ),
        const SizedBox(height: 10),
        ...items,
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: value ? Theme.of(context).colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
            ),
            child: value ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobListHeader(AppLocalizations t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.tr(en: "All Jobs", ar: "جميع الوظائف"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
            Text("${t.tr(en: "Showing", ar: "عرض")} 73 ${t.tr(en: "results", ar: "نتيجة")}", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11)),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text("${t.tr(en: "Sort by", ar: "ترتيب حسب")}: ", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12)),
                  Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), size: 16),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.grid_view, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 20),
            const SizedBox(width: 5),
            Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildJobCard({
    required String title,
    required String company,
    required String location,
    String? image,
    required int applied,
    required int capacity,
  }) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: image != null 
                ? Image.asset(image, errorBuilder: (ctx, e, s) => Icon(Icons.business, color: Theme.of(ctx).colorScheme.onSurface))
                : Icon(Icons.business, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15)),
                Text("$company • $location", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildTag("Full-Time"),
                    _buildTag("Marketing", isHighlighted: true),
                    _buildTag("Design"),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(t.tr(en: "Apply", ar: "تقديم"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Text("$applied ${t.tr(en: 'applied', ar: 'متقدم')}", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11)),
            ],
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
        color: isHighlighted ? const Color(0xFF0D2D4D) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isHighlighted ? Colors.orange.withValues(alpha: 0.5) : Colors.white12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHighlighted ? Colors.orange : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 14),
        const SizedBox(width: 10),
        _buildPageNumber("1", true),
        _buildPageNumber("2", false),
        _buildPageNumber("3", false),
        _buildPageNumber("4", false),
        _buildPageNumber("5", false),
        Text(" .. ", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38))),
        _buildPageNumber("33", false),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
      ],
    );
  }

  Widget _buildPageNumber(String num, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          num,
          style: TextStyle(color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12),
        ),
      ),
    );
  }
}

