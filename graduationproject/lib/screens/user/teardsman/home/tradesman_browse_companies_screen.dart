import 'package:flutter/material.dart';
import '../../../../shared/services/company_service.dart';
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
  bool _isTechnical = false;
  bool _isNonTechnical = false;
  String _query = '';
  bool _isLoading = true;
  List<Map<String, dynamic>> _companiesData = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _query = _searchController.text.toLowerCase()),
    );
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    try {
      final list = await CompanyService.instance.getCompanies();
      if (mounted) {
        setState(() {
          _companiesData = list.whereType<Map<String, dynamic>>().toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredCompanies() {
    var list = _companiesData;

    if (_query.isNotEmpty) {
      list = list.where((c) {
        final name =
            c['name']?.toString().toLowerCase() ??
            c['companyName']?.toString().toLowerCase() ??
            '';
        final cat =
            c['cat']?.toString().toLowerCase() ??
            c['category']?.toString().toLowerCase() ??
            '';
        return name.contains(_query) || cat.contains(_query);
      }).toList();
    }

    if (_isTechnical && !_isNonTechnical) {
      list = list.where((c) {
        final cat =
            c['cat']?.toString().toLowerCase() ??
            c['category']?.toString().toLowerCase() ??
            '';
        return cat.contains('tech');
      }).toList();
    } else if (_isNonTechnical && !_isTechnical) {
      list = list.where((c) {
        final cat =
            c['cat']?.toString().toLowerCase() ??
            c['category']?.toString().toLowerCase() ??
            '';
        return !cat.contains('tech');
      }).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredCompanies = _getFilteredCompanies();

    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
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
                                    color: Colors.black.withValues(alpha: 0.4),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
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
                        const Color(0xFFFF7A2A),
                        () => setState(() => _isTechnical = !_isTechnical),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTypeButton(
                        isAr ? 'غير تقني' : 'Non-Technical',
                        _isNonTechnical,
                        const Color(0xFFFF7A2A),
                        () =>
                            setState(() => _isNonTechnical = !_isNonTechnical),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredCompanies.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            isAr
                                ? 'لا توجد شركات مطابقة'
                                : 'No matching companies',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCompanies.length,
                        itemBuilder: (context, index) {
                          final company = filteredCompanies[index];
                          return _buildCompanyCard(
                            context,
                            company,
                            isAr,
                            isDark,
                          );
                        },
                      ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(
    String label,
    bool isSelected,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFF142C66),
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
    Map<String, dynamic> company,
    bool isAr,
    bool isDark,
  ) {
    final name =
        company['name']?.toString() ??
        company['companyName']?.toString() ??
        'Company';
    final category =
        company['cat']?.toString() ?? company['category']?.toString() ?? '';
    final logoUrl =
        company['logo']?.toString() ?? company['logoUrl']?.toString();
    final aboutEn =
        company['aboutEn']?.toString() ?? company['about']?.toString() ?? '';
    final aboutAr =
        company['aboutAr']?.toString() ?? company['about']?.toString() ?? '';
    final jobsCount = (company['jobs'] as List?)?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompanyPublicProfileScreen(company: company),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                      child: logoUrl != null && logoUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image(
                                image:
                                    getAppImageProvider(logoUrl) ??
                                    const AssetImage(
                                      'assets/company/icon/Company Logo.png',
                                    ),
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
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (category.isNotEmpty)
                            Text(
                              category,
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
                        isAr ? 'وظائف: $jobsCount' : '$jobsCount Jobs',
                        style: const TextStyle(
                          color: Color(0xFFFF7A2A),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                if (aboutEn.isNotEmpty || aboutAr.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    isAr
                        ? (aboutAr.isNotEmpty ? aboutAr : aboutEn)
                        : aboutEn.isNotEmpty
                        ? aboutEn
                        : aboutAr,
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
        ),
      ),
    );
  }
}
