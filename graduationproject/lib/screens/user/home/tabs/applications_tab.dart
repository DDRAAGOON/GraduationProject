import 'package:flutter/material.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../../../../app/router/app_router.dart';

class ApplicationsTab extends StatelessWidget {
  const ApplicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final apps = store.applications;
        final totalApps = apps.length;
        final hiredApps = apps
            .where(
              (a) =>
                  a.status.toLowerCase().contains('hire') ||
                  a.status.toLowerCase().contains('accept'),
            )
            .length;
        final percentage = totalApps > 0
            ? (hiredApps / totalApps * 100).toInt()
            : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: isAr
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr
                          ? '${store.currentUserName} صباح الخير'
                          : 'Good morning ${store.currentUserName}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                    ),
                    Text(
                      isAr
                          ? 'هذا ما قمت به بطلباتك حتى الآن'
                          : 'Here is what you have done with your applications so far',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFFD9D9D9) : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            isAr ? 'حالة التقديم' : 'Application Status',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 110,
                                child: CircularProgressIndicator(
                                  value: totalApps == 0
                                      ? 0.01
                                      : hiredApps / totalApps,
                                  strokeWidth: 12,
                                  backgroundColor: isDark
                                      ? Colors.black.withOpacity(0.1)
                                      : const Color(0xFFF0F2F5),
                                  valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFF4CAF50),
                                  ),
                                ),
                              ),
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildSmallStatCard(
                          isAr ? 'إجمالي ما تم التقديم عليه' : 'Total Applied',
                          totalApps.toString(),
                          Icons.description_outlined,
                          isDark,
                          isAr,
                        ),
                        const SizedBox(height: 16),
                        _buildSmallStatCard(
                          isAr ? 'تم اختيارك في' : 'You were selected in',
                          hiredApps.toString(),
                          Icons.check_circle_outline,
                          isDark,
                          isAr,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'السجل الأخير' : 'Recent History',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.userAllApplications),
                    child: Text(
                      isAr ? 'عرض الكل' : 'See All',
                      style: const TextStyle(color: Color(0xFF213E75)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ...apps
                  .take(3)
                  .map((app) => _buildImageAppItem(context, app, isAr, isDark)),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSmallStatCard(
    String label,
    String value,
    IconData icon,
    bool isDark,
    bool isAr,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFFD9D9D9) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: isAr
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            textAlign: isAr ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageAppItem(
    BuildContext context,
    RecruitmentApplication app,
    bool isAr,
    bool isDark,
  ) {
    final bool isHired =
        app.status.toLowerCase().contains('hire') ||
        app.status.toLowerCase().contains('accept');
    final statusColor = isHired
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9800);
    final statusText = isHired
        ? (isAr ? 'تم التوظيف' : 'Hired')
        : (isAr ? 'تم التقديم' : 'Applied');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF213E75),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAppIcon(isDark),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.jobTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAr ? 'دوام كامل •' : '• Full Time',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '2/5/2026',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.business_rounded,
        color: Color(0xFF49769F),
        size: 24,
      ),
    );
  }
}
