import 'package:flutter/material.dart';
import '../../../../constants/app_images.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../shared/state/company_store.dart';
import '../../../../shared/utils/image_helper.dart';
import 'company_public_profile_screen.dart';

class TradesmanBrowseCompaniesScreen extends StatefulWidget {
  const TradesmanBrowseCompaniesScreen({super.key});

  @override
  State<TradesmanBrowseCompaniesScreen> createState() =>
      _TradesmanBrowseCompaniesScreenState();
}

class _TradesmanBrowseCompaniesScreenState
    extends State<TradesmanBrowseCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _selectedLocation = 'All';
  bool _isTechnical = false;
  bool _isNonTechnical = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _query = _searchController.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CompanyData> _getCompanies() {
    final jobs = RecruitmentSyncStore.instance.jobs;
    final Map<String, _CompanyData> map = {};

    for (final job in jobs) {
      final key = job.companyName.toLowerCase();
      final isCurrentCompany =
          job.companyName.toLowerCase() ==
          CompanyStore.instance.companyName.toLowerCase();
      if (map.containsKey(key)) {
        map[key]!.jobs.add(job);
      } else {
        map[key] = _CompanyData(
          name: job.companyName,
          jobs: [job],
          logoUrl: isCurrentCompany
              ? CompanyStore.instance.companyProfileImage
              : null,
          industry: job.category,
          aboutEn: isCurrentCompany ? CompanyStore.instance.companyAboutEn : '',
          aboutAr: isCurrentCompany ? CompanyStore.instance.companyAboutAr : '',
          website: isCurrentCompany ? CompanyStore.instance.website : '',
          employee: isCurrentCompany ? CompanyStore.instance.employee : '',
          category: isCurrentCompany ? CompanyStore.instance.category : '',
          locations: isCurrentCompany
              ? List.from(CompanyStore.instance.locations)
              : [],
          techStack: isCurrentCompany
              ? List.from(CompanyStore.instance.techStack)
              : [],
          benefits: isCurrentCompany
              ? List.from(CompanyStore.instance.benefits)
              : [],
          foundedYear: isCurrentCompany ? CompanyStore.instance.foundedYear : 0,
        );
      }
    }

    var list = map.values.toList();

    if (_query.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.name.toLowerCase().contains(_query) ||
                c.industry.toLowerCase().contains(_query),
          )
          .toList();
    }
    if (_selectedLocation != 'All') {
      list = list
          .where((c) => c.jobs.any((j) => j.location == _selectedLocation))
          .toList();
    }
    if (_isTechnical && !_isNonTechnical) {
      list = list
          .where(
            (c) =>
                c.industry.toLowerCase().contains('tech') ||
                c.category.toLowerCase().contains('tech'),
          )
          .toList();
    } else if (_isNonTechnical && !_isTechnical) {
      list = list
          .where((c) => !c.industry.toLowerCase().contains('tech'))
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final store = RecruitmentSyncStore.instance;

    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final companies = _getCompanies();

        return Scaffold(
          backgroundColor: bgColor,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header with Background Color
              Stack(
                children: [
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF213E75),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            isAr ? 'تصفح الشركات' : 'Browse Companies',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isAr
                                ? 'اكتشف أفضل الشركات وابحث عن فرصتك المثالية.'
                                : 'Discover the best companies and find your ideal opportunity.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          // Search Bar
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 22,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: isAr
                                          ? 'اسم الشركة أو المجال...'
                                          : 'Company or industry...',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      isAr ? 'التصنيف' : 'Classification',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTypeButton(
                            isAr ? 'تقني' : 'Technical',
                            _isTechnical,
                            const Color(0xFFFF7A2A), // Orange
                            () => setState(() => _isTechnical = !_isTechnical),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTypeButton(
                            isAr ? 'غير تقني' : 'Non-Technical',
                            _isNonTechnical,
                            const Color(0xFFFF7A2A), // Orange when active
                            () => setState(
                              () => _isNonTechnical = !_isNonTechnical,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr ? 'جميع الشركات' : 'All Companies',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              isAr
                                  ? 'إجمالي الشركات المدرجة: ${companies.length}'
                                  : 'Total listed companies: ${companies.length}',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.38),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (companies.isEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 60,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.12),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isAr
                                  ? 'لا توجد شركات حالياً'
                                  : 'No companies found',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.38),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isAr
                                  ? 'سيتم عرض الشركات بعد نشر الوظائف'
                                  : 'Companies will appear once they post jobs',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.26),
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ...companies.map(
                        (c) => _buildCompanyCard(context, c, isAr),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, Color activeColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : const Color(0xFF142C66),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(
    BuildContext context,
    _CompanyData company,
    bool isAr,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CompanyPublicProfileScreen(
            company: CompanyPublicProfile(
              name: company.name,
              industry: company.industry,
              logoUrl: company.logoUrl,
              aboutEn: company.aboutEn,
              aboutAr: company.aboutAr,
              website: company.website,
              employee: company.employee,
              category: company.category,
              locations: company.locations,
              techStack: company.techStack,
              benefits: company.benefits,
              foundedYear: company.foundedYear,
              jobs: List.from(company.jobs),
            ),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: company.logoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image(
                            image: getAppImageProvider(company.logoUrl)!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.business_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.business_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (company.industry.isNotEmpty)
                        Text(
                          company.industry,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A2A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAr
                        ? 'وظائف: ${company.jobs.length}'
                        : '${company.jobs.length} Jobs',
                    style: const TextStyle(
                      color: Color(0xFFFF7A2A),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            if (company.aboutEn.isNotEmpty || company.aboutAr.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                isAr
                    ? (company.aboutAr.isNotEmpty
                          ? company.aboutAr
                          : company.aboutEn)
                    : company.aboutEn,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.54),
                  fontSize: 13,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 14),
            Divider(
              height: 1,
              thickness: 0.5,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAr ? 'عرض ملف الشركة' : 'View company profile',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyData {
  final String name;
  final List<RecruitmentJob> jobs;
  final String? logoUrl;
  final String industry;
  final String aboutEn;
  final String aboutAr;
  final String website;
  final String employee;
  final String category;
  final List<String> locations;
  final List<String> techStack;
  final List<String> benefits;
  final int foundedYear;

  _CompanyData({
    required this.name,
    required this.jobs,
    this.logoUrl,
    required this.industry,
    required this.aboutEn,
    required this.aboutAr,
    required this.website,
    required this.employee,
    required this.category,
    required this.locations,
    required this.techStack,
    required this.benefits,
    required this.foundedYear,
  });
}
