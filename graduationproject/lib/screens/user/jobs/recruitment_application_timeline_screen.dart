import 'package:flutter/material.dart';

import '../../../shared/state/recruitment_sync_store.dart';

class RecruitmentApplicationTimelineScreen extends StatefulWidget {
  const RecruitmentApplicationTimelineScreen({super.key, required this.application});

  final RecruitmentApplication application;

  @override
  State<RecruitmentApplicationTimelineScreen> createState() => _RecruitmentApplicationTimelineScreenState();
}

class _RecruitmentApplicationTimelineScreenState extends State<RecruitmentApplicationTimelineScreen> {
  String _selectedStatusTab = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    
    final allApps = store.applications;
    
    // Filter by Tab AND Search Query
    final filteredApps = allApps.where((a) {
      bool matchesTab = true;
      if (_selectedStatusTab == 'Applied') matchesTab = a.status == 'Applied' || a.status == 'تم التقديم';
      else if (_selectedStatusTab == 'Hired') matchesTab = a.status == 'Hired' || a.status == 'تم التوظيف';
      else if (_selectedStatusTab == 'In Review') matchesTab = a.status == 'In Review' || a.status == 'قيد المراجعة';
      else if (_selectedStatusTab == 'Declined') matchesTab = a.status == 'Declined' || a.status == 'مرفوض';
      else if (_selectedStatusTab != 'All') matchesTab = a.status == _selectedStatusTab;

      bool matchesSearch = a.jobTitle.toLowerCase().contains(_searchQuery) || 
                          a.companyName.toLowerCase().contains(_searchQuery);

      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isAr ? 'سجل التقديم' : 'Application Log',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isAr ? '${store.currentUserName} ،استمر في العمل الجيد' : 'Keep up the good work, ${store.currentUserName}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: const TextStyle(fontSize: 11)),
                          const SizedBox(width: 4),
                          const Icon(Icons.calendar_today, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isAr ? 'إليك ما يحدث مع طلباتك اعتباراً من اليوم' : 'Here is what\'s happening with your apps as of today',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),

          // 2. Tabs
          Container(
            color: Colors.white,
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildTab(isAr ? 'الكل' : 'All', 'All'),
                _buildTab(isAr ? 'تم التوظيف' : 'Hired', 'Hired'),
                _buildTab(isAr ? 'قيد المراجعة' : 'In Review', 'In Review'),
                _buildTab(isAr ? 'الانتظار' : 'Pending', 'Applied'),
                _buildTab(isAr ? 'مرفوض' : 'Rejected', 'Declined'),
              ],
            ),
          ),
          const Divider(height: 1),

          // 3. Search Bar Functional
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'سجل التقديم' : 'Application Log',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: isAr ? 'بحث بالوظيفة أو الشركة...' : 'Search by job or company...',
                      hintStyle: const TextStyle(color: Color(0xFF49769F), fontSize: 12),
                      icon: const Icon(Icons.search, size: 18, color: Color(0xFF49769F)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 25, child: Text('#', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text(isAr ? 'مقدم الخدمة / الشركة' : 'Company', style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text(isAr ? 'المسمى الوظيفي' : 'Job Title', style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text(isAr ? 'تاريخ التقديم' : 'Date', style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text(isAr ? 'الحالة' : 'Status', style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),

          // 5. Table Body
          Expanded(
            child: filteredApps.isEmpty 
              ? Center(child: Text(isAr ? 'لا توجد نتائج' : 'No matching results'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: filteredApps.length,
                  itemBuilder: (context, index) {
                    final app = filteredApps[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
                      child: Row(
                        children: [
                          SizedBox(width: 25, child: Text('${index + 1}', style: const TextStyle(fontSize: 12, color: Colors.black87))),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                                  child: const Icon(Icons.business, size: 14, color: Colors.orange),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(app.companyName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          Expanded(flex: 3, child: Text(app.jobTitle, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 2, child: Text('${app.updatedAt.day}/${app.updatedAt.month}/${app.updatedAt.year}', style: const TextStyle(fontSize: 11, color: Colors.black54))),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getStatusColor(app.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                app.status,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: _getStatusColor(app.status), fontSize: 10, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
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

  Color _getStatusColor(String status) {
    if (status == 'Hired' || status == 'تم التوظيف') return Colors.green;
    if (status == 'Declined' || status == 'مرفوض') return Colors.red;
    if (status == 'In Review' || status == 'قيد المراجعة') return Colors.orange;
    return Colors.blue;
  }

  Widget _buildTab(String label, String status) {
    final isSelected = _selectedStatusTab == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatusTab = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: isSelected ? const Color(0xFF49769F) : Colors.transparent, width: 3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF49769F) : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
