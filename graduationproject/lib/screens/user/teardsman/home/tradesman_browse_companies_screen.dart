import 'package:flutter/material.dart';
import 'dart:io';
import '../../profile/user_data.dart';
import '../setting/settings.dart';
import '../../../../shared/state/recruitment_sync_store.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings())),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: UserProfileData.profileImage != null
                      ? (UserProfileData.profileImage!.startsWith('http') 
                          ? NetworkImage(UserProfileData.profileImage!) 
                          : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                      : null,
                  child: UserProfileData.profileImage == null 
                      ? const Icon(Icons.person, size: 20, color: Colors.grey) 
                      : null,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          isAr ? 'تصفح الشركات' : 'Browse Companies',
          style: const TextStyle(color: Color(0xFF011931), fontWeight: FontWeight.w800, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings())),
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF011931)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 24),
          // Hero Title
          Text(
            isAr ? 'ابحث عن شركات أحلامك' : 'Search for companies you dream of',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF011931), height: 1.1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isAr 
                ? 'اكتشف أفضل الشركات وبيئات العمل المثالية لمستقبلك المهني' 
                : 'Discover the best companies and ideal work environments for your professional future',
            style: const TextStyle(fontSize: 14, color: Colors.black45, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Modern Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF49769F).withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                // Search Input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: Color(0xFF49769F), size: 20),
                      hintText: isAr ? 'اسم الشركة أو المجال...' : 'Company or industry...',
                      border: InputBorder.none,
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Location Selection (Dropdown)
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLocation,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF49769F)),
                            items: RecruitmentSyncStore.egyptGovernorates.map((String gov) {
                              return DropdownMenuItem<String>(
                                value: gov,
                                child: Text(
                                  gov,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedLocation = val);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Search Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF49769F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(isAr ? 'بحث' : 'Search', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            isAr ? 'التصنيف' : 'Classification',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF011931)),
          ),
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
                  Text(
                    isAr ? 'جميع الشركات' : 'All Companies',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Color(0xFF011931)),
                  ),
                  Text(
                    isAr ? 'إجمالي الشركات المدرجة: 1' : 'Total listed companies: 1',
                    style: const TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(Icons.sort_rounded, color: Color(0xFF49769F)),
            ],
          ),
          const SizedBox(height: 20),
          
          // Company Card
          _buildCompanyCard(
            context: context,
            name: 'dragon',
            desc: isAr ? 'شركة رائدة في مجالها تقدم حلولاً تقنية مبتكرة.' : 'A leading company in its field providing innovative tech solutions.',
            industry: isAr ? 'خدمات عامة' : 'General Services',
            vacancies: 1,
            isAr: isAr,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF49769F) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF49769F) : Colors.grey.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF49769F).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard({
    required BuildContext context,
    required String name,
    required String desc,
    required String industry,
    required int vacancies,
    required bool isAr,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.business_rounded, color: Color(0xFF49769F), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF011931)),
                    ),
                    Text(
                      industry,
                      style: const TextStyle(color: Color(0xFF49769F), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A2A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAr ? 'وظائف: $vacancies' : '$vacancies Jobs',
                  style: const TextStyle(color: Color(0xFFFF7A2A), fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAr ? 'عرض ملف الشركة' : 'View company profile',
                style: const TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF49769F)),
            ],
          ),
        ],
      ),
    );
  }
}
