import 'package:flutter/material.dart';
import 'dart:io';
import '../../profile/user_data.dart';
import '../setting/settings.dart';

class TradesmanBrowseCompaniesScreen extends StatefulWidget {
  const TradesmanBrowseCompaniesScreen({super.key});

  @override
  State<TradesmanBrowseCompaniesScreen> createState() => _TradesmanBrowseCompaniesScreenState();
}

class _TradesmanBrowseCompaniesScreenState extends State<TradesmanBrowseCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isTechnical = false;
  bool _isNonTechnical = false;

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings())),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: UserProfileData.profileImage != null
                    ? (UserProfileData.profileImage!.startsWith('http') 
                        ? NetworkImage(UserProfileData.profileImage!) 
                        : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                    : null,
                child: UserProfileData.profileImage == null ? const Icon(Icons.person, color: Colors.white) : null,
              ),
            ),
          ),
        ),
        title: Text(
          isAr ? 'تصفح الشركات' : 'Browse Companies',
          style: const TextStyle(color: Color(0xFF011931), fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings())),
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF011931), size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 30),
          Text(
            isAr ? 'ابحث عن الشركات التي تحلم بها' : 'Search for companies you dream of',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF011931), height: 1.1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            isAr 
                ? 'اكتشف أفضل الشركات وبيئات العمل المثالية لمستقبلك المهني' 
                : 'Discover the best companies and ideal work environments for your professional future',
            style: const TextStyle(fontSize: 15, color: Colors.black45, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black38, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: isAr ? 'الشركة...' : 'Company o...',
                        border: InputBorder.none,
                        hintStyle: const TextStyle(fontSize: 13, color: Colors.black26),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_outlined, color: Colors.black38, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: isAr ? 'أي مكان' : 'Anyw...',
                        border: InputBorder.none,
                        hintStyle: const TextStyle(fontSize: 13, color: Colors.black26),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF49769F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  child: Text(isAr ? 'بحث' : 'Search', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            isAr ? 'التصنيف' : 'Classification',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Color(0xFF011931)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTypeButton('Technical', _isTechnical, () => setState(() => _isTechnical = !_isTechnical))),
              const SizedBox(width: 16),
              Expanded(child: _buildTypeButton('Non-Technical', _isNonTechnical, () => setState(() => _isNonTechnical = !_isNonTechnical))),
            ],
          ),
          
          const SizedBox(height: 40),
          
          Text(
            isAr ? 'جميع الشركات' : 'All Companies',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Color(0xFF011931)),
          ),
          Text(
            isAr ? 'إجمالي الشركات المدرجة: 3' : 'Total listed companies: 3',
            style: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          
          // Company Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF0F3FF), borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.business_outlined, color: Color(0xFF49769F), size: 32),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F3FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF49769F).withOpacity(0.1)),
                      ),
                      child: Text(
                        isAr ? 'وظائف شاغرة 1' : '1 Vacancies',
                        style: const TextStyle(color: Color(0xFF49769F), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'dragon',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, color: Color(0xFF011931)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A leading company in its field',
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'General Services',
                        style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF49769F)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF49769F) : Colors.grey.withOpacity(0.15), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF49769F) : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
