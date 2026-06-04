import 'package:flutter/material.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../app/router/app_router.dart';

class RecruitmentAllApplicationsScreen extends StatefulWidget {
  const RecruitmentAllApplicationsScreen({super.key});

  @override
  State<RecruitmentAllApplicationsScreen> createState() => _RecruitmentAllApplicationsScreenState();
}

class _RecruitmentAllApplicationsScreenState extends State<RecruitmentAllApplicationsScreen> {
  String _activeTab = 'الكل';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _translateStatus(String status, bool isAr) {
    final low = status.toLowerCase();
    if (low.contains('hire') || low.contains('accept')) return isAr ? 'تم التوظيف' : 'Hired';
    if (low.contains('reject') || low.contains('decline')) return isAr ? 'تم الرفض' : 'Rejected';
    if (low.contains('wait')) return isAr ? 'Waitlist' : 'Waitlist';
    if (low.contains('review') || low.contains('interview')) return isAr ? 'قيد المراجعة' : 'Under Review';
    return isAr ? 'تم التقديم' : 'Applied';
  }

  Color _getStatusColor(String status) {
    final low = status.toLowerCase();
    if (low.contains('hire') || low.contains('accept')) return const Color(0xFF4CAF50);
    if (low.contains('reject') || low.contains('decline')) return const Color(0xFFF44336);
    if (low.contains('wait')) return const Color(0xFF2196F3);
    return const Color(0xFFFF9800);
  }

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final filteredApps = store.applications.where((app) {
      final matchesSearch = app.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           app.companyName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (_activeTab == 'الكل' || _activeTab == 'All') return matchesSearch;
      
      final status = _translateStatus(app.status, isAr);
      return matchesSearch && status == _activeTab;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Applications Record
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    isAr ? 'سجل التقديمات' : 'Applications Record',
                    style: const TextStyle(color: Color(0xFFFF7A2A), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Main Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D2D4D) : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: '${store.currentUserName} ', style: const TextStyle(color: Color(0xFFFF7A2A))),
                          TextSpan(text: isAr ? 'استمر في العمل الجيد' : 'keep up the good work', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF213E75))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAr ? 'إليك ما يحدث مع طلباتك اعتباراً من اليوم' : 'Here is what is happening with your applications as of today',
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Tabs inside card - Ordered from Right (First child in RTL)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCardTab(isAr ? 'الكل' : 'All'),
                          _buildCardTab(isAr ? 'تم التوظيف' : 'Hired'),
                          _buildCardTab(isAr ? 'قيد المراجعة' : 'Review'),
                          _buildCardTab(isAr ? 'تم التقديم' : 'Applied'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  isAr ? 'سجل الطلبات' : 'Applications Record',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar in Dark Blue Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF142C66),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECEAF2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: isAr ? 'ابحث عن الوظيفة أو الشركة...' : 'Search by job or company...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // List of Applications
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredApps.length,
                itemBuilder: (context, index) {
                  final app = filteredApps[index];
                  final status = _translateStatus(app.status, isAr);
                  final color = _getStatusColor(app.status);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        // Right: Logo (First child in Row for RTL)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.business, size: 20, color: Color(0xFF49769F)),
                        ),
                        const SizedBox(width: 12),
                        // Middle: Job Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: isAr ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                            children: [
                              Text(
                                app.jobTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                isAr ? 'دوام كامل •' : 'Full Time •',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Left: Date (Top) and Status (Bottom)
                        Column(
                          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${app.updatedAt.day}/${app.updatedAt.month}/${app.updatedAt.year}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTab(String label) {
    final isSelected = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: isSelected ? const Border(bottom: BorderSide(color: Color(0xFFFF7A2A), width: 3)) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFF7A2A) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
