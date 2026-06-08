import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/recruitment_sync_store.dart';
import '../edit_profile_screen.dart';
import '../profile_login_details_screen.dart';
import 'preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final store = RecruitmentSyncStore.instance;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              t.notifications,
              style: TextStyle(color: onSurfaceColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Let Directionality handle it
              children: [
                const SizedBox(height: 30),

                // Notification Settings Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Start = Right in RTL
                  children: [
                    Text(
                      t.tr(en: "Notification Settings", ar: "إعدادات الإشعارات"), 
                      style: TextStyle(color: onSurfaceColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.tr(en: "Choose how and when you want to receive notifications from us.", ar: "اختر كيف ومتى تود استلام الإشعارات منا."), 
                      style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.7), fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                _buildNotificationOption(
                  context,
                  t.tr(en: "Email Notifications", ar: "إشعارات البريد الإلكتروني"),
                  t.tr(en: "Receive weekly summary for jobs and articles", ar: "استلم ملخصاً أسبوعياً للوظائف والمقالات"),
                  store.emailNotifications,
                  (val) {
                    store.updateNotificationSettings(email: val);
                  },
                  onSurfaceColor,
                  isAr,
                ),
                _buildNotificationOption(
                  context,
                  t.tr(en: "Job Alerts", ar: "تنبيهات الوظائف"),
                  t.tr(en: "When new jobs that match your skills are posted", ar: "عند نشر وظيفة جديدة تناسب مهاراتك"),
                  store.jobAlerts,
                  (val) {
                    store.updateNotificationSettings(jobs: val);
                  },
                  onSurfaceColor,
                  isAr,
                ),
                _buildNotificationOption(
                  context,
                  t.tr(en: "Application Updates", ar: "تحديثات الطلبات"),
                  t.tr(en: "When your application status changes", ar: "عند تغير حالة طلبات التوظيف الخاصة بك"),
                  store.applicationUpdates,
                  (val) {
                    store.updateNotificationSettings(updates: val);
                  },
                  onSurfaceColor,
                  isAr,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem(BuildContext context, String title, bool isActive, VoidCallback onTap, bool isDark, Color onSurfaceColor) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? Theme.of(context).colorScheme.primary : onSurfaceColor.withValues(alpha: 0.5), 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal, 
              fontSize: 14,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationOption(BuildContext context, String title, String subtitle, bool value, ValueChanged<bool> onChanged, Color onSurfaceColor, bool isAr) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Respects RTL/LTR automatically
              children: [
                Text(
                  title, 
                  style: TextStyle(color: onSurfaceColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.6), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
          ),
        ],
      ),
    );
  }
}

