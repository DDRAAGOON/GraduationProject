import 'package:flutter/material.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../app/router/app_router.dart';

class RecruitmentAllApplicationsScreen extends StatelessWidget {
  const RecruitmentAllApplicationsScreen({super.key});

  String _translateValue(String? value, bool isAr) {
    if (value == null || value.isEmpty || !isAr) return value ?? "";
    final low = value.trim().toLowerCase();
    if (low == 'full-time' || low == 'full time') return 'دوام كامل';
    if (low.contains('hire')) return 'تم التوظيف';
    if (low.contains('reject') || low.contains('decline')) return 'تم الرفض';
    if (low.contains('pend')) return 'قيد الانتظار';
    if (low.contains('appli')) return 'تم التقديم';
    if (low.contains('interview')) return 'مقابلة';
    if (low.contains('review')) return 'قيد المراجعة';
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final apps = store.applications;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isAr ? 'السجلات' : 'Application Records'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: apps.isEmpty
          ? Center(child: Text(isAr ? 'لا يوجد سجلات حالياً' : 'No records yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                final isHired = app.status.toLowerCase().contains('hire');
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.userApplicationTimeline, arguments: app),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.business, color: Color(0xFF49769F)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text('${app.companyName} • ${_translateValue("Full-time", isAr)}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${app.updatedAt.day}/${app.updatedAt.month}/${app.updatedAt.year}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (isHired ? Colors.green : Colors.orange).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _translateValue(app.status, isAr),
                                  style: TextStyle(color: isHired ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
