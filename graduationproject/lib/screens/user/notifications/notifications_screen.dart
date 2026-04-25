import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final List<dynamic> notifications = []; // Currently empty to show 'no notification' state

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.notifications,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.tr(en: "No notifications yet", ar: "لا توجد إشعارات بعد"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    t.tr(en: "You have ${notifications.length} Notifications today.", ar: "لديك ${notifications.length} إشعارات اليوم."),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  // List would go here...
                ],
              ),
            ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String name,
    required String action,
    required String time,
    String? image,
    String? initials,
    bool isUnread = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isUnread)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.12),
          backgroundImage: image != null ? AssetImage(image) : null,
          child: initials != null
            ? Text(initials, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold))
            : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                  children: [
                    TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: " "),
                    TextSpan(text: action, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54))),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
