import 'package:flutter/material.dart';
import '../setting/settings.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../shared/state/company_store.dart';
import '../../../../shared/utils/image_helper.dart';
import 'company_public_profile_screen.dart';

class TradesmanBrowseCompaniesScreen extends StatefulWidget {
  const TradesmanBrowseCompaniesScreen({super.key});

  @override
  State<TradesmanBrowseCompaniesScreen> createState() => _TradesmanBrowseCompaniesScreenState();
}

class _TradesmanBrowseCompaniesScreenState extends State<TradesmanBrowseCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'All';
  bool _isTechnical = false;
  bool _isNonTechnical = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _query = _searchController.text.toLowerCase()));
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

  List<_CompanyData> _getCompanies() {
    final jobs = RecruitmentSyncStore.instance.jobs;
    final Map<String, _CompanyData> map = {};

    for (final job in jobs) {
      final key = job.companyName.toLowerCase();
      final isCurrentCompany = job.companyName.toLowerCase() == CompanyStore.instance.companyName.toLowerCase();
      if (map.containsKey(key)) {
        map[key]!.jobs.add(job);
      } else {
        map[key] = _CompanyData(
          name: job.companyName,
          jobs: [job],
          logoUrl: isCurrentCompany ? CompanyStore.instance.companyProfileImage : null,
          industry: job.category,
          aboutEn: isCurrentCompany ? CompanyStore.instance.companyAboutEn : '',
          aboutAr: isCurrentCompany ? CompanyStore.instance.companyAboutAr : '',
          website: isCurrentCompany ? CompanyStore.instance.website : '',
          employee: isCurrentCompany ? CompanyStore.instance.employee : '',
          category: isCurrentCompany ? CompanyStore.instance.category : '',
          locations: isCurrentCompany ? List.from(CompanyStore.instance.locations) : [],
          techStack: isCurrentCompany ? List.from(CompanyStore.instance.techStack) : [],
          benefits: isCurrentCompany ? List.from(CompanyStore.instance.benefits) : [],
          foundedYear: isCurrentCompany ? CompanyStore.instance.foundedYear : 0,
        );
      }
    }

    var list = map.values.toList();

    if (_query.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(_query) || c.industry.toLowerCase().contains(_query)).toList();
    }
    if (_selectedLocation != 'All') {
      list = list.where((c) => c.jobs.any((j) => j.location == _selectedLocation)).toList();
    }
    if (_isTechnical && !_isNonTechnical) {
      list = list.where((c) => c.industry.toLowerCase().contains('tech') || c.category.toLowerCase().contains('tech')).toList();
    } else if (_isNonTechnical && !_isTechnical) {
      list = list.where((c) => !c.industry.toLowerCase().contains('tech')).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final store = RecruitmentSyncStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final companies = _getCompanies();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leadingWidth: 70,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Center(
                child: GestureDetector(
                  onTap: () => _showProfileImage(context, getAppImageProvider(store.profileImage)),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).cardColor,
                      backgroundImage: getAppImageProvider(store.profileImage),
                      child: store.profileImage == null
                          ? Icon(Icons.person, size: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38))
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              isAr ? 'تصفح الشركات' : 'Browse Companies',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w800, fontSize: 22),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings())),
                icon: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 24),
              Text(
                isAr ? 'ابحث عن شركات أحلامك' : 'Search for companies you dream of',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface, height: 1.1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isAr
                    ? 'اكتشف أفضل الشركات وبيئات العمل المثالية لمستقبلك المهني'
                    : 'Discover the best companies and ideal work environments for your professional future',
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Search & Filter Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                  boxShadow: isDark ? [] : [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Theme.of(context).colorScheme.primary, size: 20),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: isAr ? 'اسم الشركة أو المجال...' : 'Company or industry...',
                          hintStyle: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    Container(height: 24, width: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLocation,
                          isExpanded: true,
                          dropdownColor: Theme.of(context).cardColor,
                          icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 18),
                          items: RecruitmentSyncStore.egyptGovernorates.map((String gov) {
                            return DropdownMenuItem<String>(
                              value: gov,
                              child: Text(gov, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                            );
                          }).toList(),
                          onChanged: (val) { if (val != null) setState(() => _selectedLocation = val); },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(isAr ? 'التصنيف' : 'Classification',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTypeButton(isAr ? 'تقني' : 'Technical', _isTechnical, () => setState(() => _isTechnical = !_isTechnical))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTypeButton(isAr ? 'غير تقني' : 'Non-Technical', _isNonTechnical, () => setState(() => _isNonTechnical = !_isNonTechnical))),
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
                      Text(isAr ? 'جميع الشركات' : 'All Companies',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Theme.of(context).colorScheme.onSurface)),
                      Text(
                        isAr ? 'إجمالي الشركات المدرجة: ${companies.length}' : 'Total listed companies: ${companies.length}',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12, fontWeight: FontWeight.w500),
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
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Icon(Icons.business_outlined, size: 60, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                      const SizedBox(height: 16),
                      Text(
                        isAr ? 'لا توجد شركات حالياً' : 'No companies found',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isAr ? 'سيتم عرض الشركات بعد نشر الوظائف' : 'Companies will appear once they post jobs',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.26), fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...companies.map((c) => _buildCompanyCard(context, c, isAr)),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor.withValues(alpha: 0.15), width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87), fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, _CompanyData company, bool isAr) {
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
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                  child: company.logoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image(
                            image: getAppImageProvider(company.logoUrl)!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(Icons.business_rounded, color: Theme.of(context).colorScheme.primary, size: 28),
                          ),
                        )
                      : Icon(Icons.business_rounded, color: Theme.of(context).colorScheme.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company.name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Theme.of(context).colorScheme.onSurface)),
                      if (company.industry.isNotEmpty)
                        Text(company.industry, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFFF7A2A).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    isAr ? 'وظائف: ${company.jobs.length}' : '${company.jobs.length} Jobs',
                    style: const TextStyle(color: Color(0xFFFF7A2A), fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            if (company.aboutEn.isNotEmpty || company.aboutAr.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                isAr ? (company.aboutAr.isNotEmpty ? company.aboutAr : company.aboutEn) : company.aboutEn,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13, height: 1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 14),
            Divider(height: 1, thickness: 0.5, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAr ? 'عرض ملف الشركة' : 'View company profile',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Icon(Icons.arrow_forward_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
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
