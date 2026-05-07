import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import 'tradesman_job_details_screen.dart';

class TradesmanHomeScreen extends StatelessWidget {
  final Function(int) onTabChange;
  const TradesmanHomeScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;
    final colorScheme = Theme.of(context).colorScheme;

    // النصوص المطلوبة مباشرة لضمان الظهور الفوري
    final String findJobText = l10n.isAr ? "ابحث عن عمل سريع" : "Find a quick job";
    final String searchHintText = l10n.isAr ? "ابحث عن مهنة (سباك، كهربائي...)" : "Search for a trade...";

    final List<String> companyLogos = [
      'assets/tradesman/images.png',
      'assets/tradesman/damson.webp',
      'assets/tradesman/images2.jpg',
      'assets/tradesman/images (1).png',
      'assets/tradesman/ecniiRa5PnjVDWpfybyZ.jpg',
      'assets/tradesman/LOGO-الشريف-ابيض-لصرف-المياه.webp',
      'assets/tradesman/2976393872801202603251042184218.webp',
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1581244277943-fe4a9c777189?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      findJobText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2))],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(Icons.search, color: colorScheme.primary, size: 26),
                          Expanded(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(color: colorScheme.onSurface),
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  store.updateFilters(searchQuery: value.trim());
                                  onTabChange(1);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: searchHintText,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              onPressed: () {
                                onTabChange(1);
                              },
                              icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.featuredOpportunities,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.featuredOpportunitiesSub,
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                // Horizontal list of company logos
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: companyLogos.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => onTabChange(3), // Navigate to Companies tab
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                companyLogos[index],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.business, color: colorScheme.primary.withValues(alpha: 0.5)),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.suggestedJobs,
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onTabChange(1),
                      child: Text(
                        l10n.seeAll,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (store.jobs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        l10n.noJobsAvailable,
                        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      ),
                    ),
                  )
                else
                  ...store.jobs.where((j) => j.category.toLowerCase() == 'tradesman' || j.category.toLowerCase() == 'service').take(3).map((job) => _buildFeaturedJobCard(context, job, l10n)),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedJobCard(BuildContext context, RecruitmentJob job, AppLocalizations l10n) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TradesmanJobDetailsScreen(job: job),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(job.logoIcon ?? Icons.work_outline, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.translateJobTitle(job.title),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.translateCompanyName(job.companyName),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconText(context, Icons.location_on_outlined, l10n.translateLocation(job.location), Theme.of(context).colorScheme.primary),
                  Text(
                    l10n.translateSalary(job.salaryRange),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
