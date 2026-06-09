import 'package:flutter/material.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../shared/services/recruitment_sync_service.dart';
import '../../../../app/router/app_router.dart';
import 'recruitment_ui_utils.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  late TextEditingController _searchController;
  final store = RecruitmentSyncStore.instance;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: store.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchBarColor = isDark ? const Color(0xFFECEAF2) : Colors.white;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, _) {
        final jobs = store.filteredJobs;
        return RefreshIndicator(
          onRefresh: () => RecruitmentSyncService.instance.startPolling(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF213E75),
                        borderRadius: BorderRadius.circular(24),
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
                            isAr ? "ابحث عن وظائف" : "Search for jobs",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr
                                ? "اكتشف الاف الفرص الوظيفيه و ابدا مسيرتك المهنيه"
                                : "Discover thousands of job opportunities and start your career",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECEAF2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                          onChanged: (value) =>
                                              store.updateFilters(
                                                searchQuery: value.trim(),
                                              ),
                                          decoration: InputDecoration(
                                            hintText: isAr
                                                ? 'ابحث...'
                                                : 'Search...',
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            filled: false,
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: store.filterLocation,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        items: RecruitmentSyncStore
                                            .egyptGovernorates
                                            .map(
                                              (gov) => DropdownMenuItem(
                                                value: gov,
                                                child: Text(
                                                  translateValue(gov, isAr),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null)
                                            store.updateFilters(
                                              location: value,
                                            );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF7A2A),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            children: [
                              TextSpan(text: isAr ? "جميع " : "All "),
                              TextSpan(
                                text: isAr ? "الوظائف" : "Jobs",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.userAdvancedFilters),
                            icon: Icon(
                              Icons.tune,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              final job = jobs[index - 1];
              return _buildFeaturedJobCardFull(context, job, isAr);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedJobCardFull(
    BuildContext context,
    RecruitmentJob job,
    bool isAr,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.userJobDetails, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCompanyLogo(context, job.companyLogoUrl),
            const SizedBox(height: 12),
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              job.companyName,
              style: const TextStyle(
                color: Color(0xFFFF7A2A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            if (job.description.isNotEmpty)
              _buildPreviewText(
                isAr ? "الوصف" : "Description",
                job.description,
                isAr,
              ),
            if (job.qualifications.isNotEmpty)
              _buildPreviewText(
                isAr ? "المؤهلات" : "Qualifications",
                job.qualifications.join(', '),
                isAr,
              ),
            if (job.responsibilities.isNotEmpty)
              _buildPreviewText(
                isAr ? "المسؤوليات" : "Responsibilities",
                job.responsibilities.join(', '),
                isAr,
              ),
            if (job.benefits.isNotEmpty)
              _buildPreviewText(
                isAr ? "مزايا إضافية" : "Extra Benefits",
                job.benefits.join(' • '),
                isAr,
                isBenefit: true,
              ),
            const SizedBox(height: 12),
            buildWhiteTag(translateValue(job.type, isAr)),
            const SizedBox(height: 24),
            Row(
              children: [
                if (isAr) ...[
                  Text(
                    "المقبولين: ${job.acceptedCount} / ${job.capacity}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Spacer(),
                  _buildApplyActionBtn(context, job, isAr),
                ] else ...[
                  _buildApplyActionBtn(context, job, isAr),
                  const Spacer(),
                  Text(
                    "Accepted: ${job.acceptedCount} / ${job.capacity}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewText(
    String label,
    String text,
    bool isAr, {
    bool isBenefit = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$label: $text",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isBenefit ? const Color(0xFF4CAF50) : Colors.white70,
          fontSize: 12,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildApplyActionBtn(
    BuildContext context,
    RecruitmentJob job,
    bool isAr,
  ) {
    return ElevatedButton(
      onPressed: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.userJobApplication, arguments: job),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF142C66),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      child: Text(
        isAr ? "تقديم" : "Apply",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
