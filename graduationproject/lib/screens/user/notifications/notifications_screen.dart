import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF0D2D4D) : Colors.white;

    // Mock notifications for design testing
    final List<Map<String, String>> notifications = [
      {
        'title': 'تم استلام طلبك',
        'body': 'لقد استلمت شركة Nexora Solutions طلب التقديم الخاص بك بنجاح.',
        'time': 'منذ 5 دقائق',
        'type': 'application'
      },
      {
        'title': 'رسالة جديدة',
        'body': 'لقد أرسل لك مساعد جوبيتو الذكي نصيحة مهنية جديدة.',
        'time': 'منذ ساعة',
        'type': 'message'
      },
      {
        'title': 'وظيفة مقترحة',
        'body': 'هناك وظيفة مطور تطبيقات جديدة تناسب مهاراتك في القاهرة.',
        'time': 'منذ ساعتين',
        'type': 'job'
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.notifications,
          style: TextStyle(color: onSurfaceColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: onSurfaceColor.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.tr(en: "No notifications yet", ar: "لا توجد إشعارات بعد"),
                    style: TextStyle(
                      color: onSurfaceColor.withValues(alpha: 0.38),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final note = notifications[index];
                IconData icon;
                Color iconColor;
                
                switch (note['type']) {
                  case 'message': icon = Icons.chat_bubble_outline; iconColor = Colors.blue; break;
                  case 'job': icon = Icons.work_outline; iconColor = Colors.orange; break;
                  default: icon = Icons.check_circle_outline; iconColor = Colors.green;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  note['title']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: onSurfaceColor,
                                  ),
                                ),
                                Text(
                                  note['time']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: onSurfaceColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              note['body']!,
                              style: TextStyle(
                                fontSize: 13,
                                color: onSurfaceColor.withOpacity(0.7),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
