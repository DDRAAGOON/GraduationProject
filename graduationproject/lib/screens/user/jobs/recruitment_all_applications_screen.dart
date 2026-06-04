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
    
    final filteredApps = store.applications.where((app) {
      final matchesSearch = app.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           app.companyName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (_activeTab == 'الكل' || _activeTab == 'All') return matchesSearch;
      
      final status = _translateStatus(app.status, isAr);
      return matchesSearch && status == _activeTab;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isAr ? 'سجل التقديم' : 'Application History',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text(
                        '2/6/2026',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isAr ? '${store.currentUserName} ,استمر في العمل الجيد' : '${store.currentUserName}, keep up the good work',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        isAr ? 'إليك ما يحدث مع طلباتك اعتباراً من اليوم' : 'Here is what is happening with your applications as of today',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab(isAr ? 'الكل' : 'All'),
                _buildTab(isAr ? 'تم التوظيف' : 'Hired'),
                _buildTab(isAr ? 'قيد المراجعة' : 'Review'),
                _buildTab(isAr ? 'تم التقديم' : 'Applied'),
                _buildTab(isAr ? 'مرفوض' : 'Rejected'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // List Header & Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isAr ? 'سجل الطلبات' : 'Applications Record',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: isAr ? 'بحث بالوظيفة أو الشركة...' : 'Search by job or company...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF213E75)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(isAr ? 'الحالة' : 'Status', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
                Expanded(flex: 2, child: Text(isAr ? 'التاريخ' : 'Date', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
                Expanded(flex: 3, child: Text(isAr ? 'المسمى الوظيفي' : 'Job Title', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
                Expanded(flex: 3, child: Text(isAr ? 'مقدم الخدمة / الشركة' : 'Company', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
                const SizedBox(width: 30, child: Text('#', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
              ],
            ),
          ),
          const Divider(indent: 24, endIndent: 24),

          // Applications List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: filteredApps.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final app = filteredApps[index];
                final status = _translateStatus(app.status, isAr);
                final color = _getStatusColor(app.status);

                return InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.userApplicationTimeline, arguments: app),
                  child: Row(
                    children: [
                      // Status
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Date
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${app.updatedAt.day}/${app.updatedAt.month}/${app.updatedAt.year}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                      // Job Title
                      Expanded(
                        flex: 3,
                        child: Text(
                          app.jobTitle,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      // Company
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                             Text(
                              app.companyName,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.business, size: 16, color: Color(0xFFF77F32)),
                            ),
                          ],
                        ),
                      ),
                      // Index
                      SizedBox(
                        width: 30,
                        child: Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    final isSelected = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF213E75) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF213E75) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
