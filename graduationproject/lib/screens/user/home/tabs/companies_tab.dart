import 'package:flutter/material.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../shared/services/company_service.dart';
import '../../../../app/router/app_router.dart';
import 'recruitment_ui_utils.dart';

class CompaniesTab extends StatefulWidget {
  const CompaniesTab({super.key});
  @override
  State<CompaniesTab> createState() => _CompaniesTabState();
}

class _CompaniesTabState extends State<CompaniesTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = 'الكل';
  bool _isLoading = true;
  List<Map<String, dynamic>> _companiesData = [];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _companiesData.where((c) {
      final name =
          c['name']?.toString() ?? c['companyName']?.toString() ?? 'Company';
      final category =
          c['cat']?.toString() ?? c['category']?.toString() ?? 'Non-Tech';

      final matchesSearch = name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCat =
          _selectedCategory == 'الكل' || category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
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
                children: [
                  Text(
                    isAr ? 'تصفح الشركات' : 'Browse Companies',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAr
                        ? 'اكتشف أفضل الشركات وابحث عن فرصتك المثالية.'
                        : 'Discover best companies and find your ideal opportunity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
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
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  textAlign: isAr
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  onChanged: (v) =>
                                      setState(() => _searchQuery = v),
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    hintText: isAr
                                        ? 'ابحث عن شركة...'
                                        : 'Search for company...',
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
                                value: 'All',
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: ['All', 'Cairo', 'Giza']
                                    .map(
                                      (gov) => DropdownMenuItem(
                                        value: gov,
                                        child: Text(translateValue(gov, isAr)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {},
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
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: isAr
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: isAr
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    isAr ? 'التصنيف' : 'Category',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(
                          () => _selectedCategory =
                              _selectedCategory == 'Non-Tech'
                              ? 'الكل'
                              : 'Non-Tech',
                        ),
                        child: _buildCategoryBtn(
                          isAr ? 'غير تقني' : 'Non-Tech',
                          _selectedCategory == 'Non-Tech',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(
                          () => _selectedCategory =
                              _selectedCategory == 'Technical'
                              ? 'الكل'
                              : 'Technical',
                        ),
                        child: _buildCategoryBtn(
                          isAr ? 'تقني' : 'Technical',
                          _selectedCategory == 'Technical',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: isAr
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'جميع الشركات' : 'All Companies',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isAr
                      ? 'إجمالي الشركات المدرجة: ${filtered.length}'
                      : 'Total listed companies: ${filtered.length}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 20),
                ...filtered.map(
                  (company) =>
                      _buildCompanyCard(context, company, isAr, isDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCategoryBtn(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF7A2A) : const Color(0xFF142C66),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
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
    final jobsCount =
        int.tryParse(company['jobsCount']?.toString() ?? '') ??
        int.tryParse(company['jobs']?.toString() ?? '') ??
        0;
    final industry =
        company['industry']?.toString() ??
        company['category']?.toString() ??
        (isAr ? 'خدمات عامة' : 'General Services');
    final descriptionEn =
        company['aboutEn']?.toString() ??
        company['description']?.toString() ??
        'A leading company in integrated solutions and innovation.';
    final descriptionAr =
        company['aboutAr']?.toString() ??
        company['description']?.toString() ??
        'شركة رائدة في مجال الحلول المتكاملة والابتكار.';
    final desc = isAr ? descriptionAr : descriptionEn;
    final logoUrl =
        company['logoUrl']?.toString() ??
        company['photoUrl']?.toString() ??
        company['avatar']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: isAr
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isAr
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isAr ? 'وظائف شاغرة $jobsCount' : '$jobsCount Vacant Jobs',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCompanyIcon(
            logoUrl: logoUrl,
            fallback: company['logo'] as IconData? ?? Icons.business,
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              industry,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          Align(
            alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.userCompanyDetails, arguments: company),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isAr)
                    const Text(
                      'View Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  Icon(
                    isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                    size: 14,
                    color: const Color(0xFFFF7A2A),
                  ),
                  if (isAr)
                    const Text(
                      'عرض الملف الشخصي',
                      style: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyIcon({String? logoUrl, required IconData fallback}) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2FF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: logoUrl != null && logoUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(fallback, color: const Color(0xFF49769F), size: 30),
              ),
            )
          : Icon(fallback, color: const Color(0xFF49769F), size: 30),
    );
  }
}
