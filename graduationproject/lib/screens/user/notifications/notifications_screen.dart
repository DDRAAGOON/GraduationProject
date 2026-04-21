import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              t.tr(en: "You have 2 Notifications today.", ar: "لديك إشعاران اليوم."),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Today Section
            Text(
              t.tr(en: "Today", ar: "اليوم"),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildNotificationItem(
              context,
              name: "Joe Bartmann",
              action: "Send you a message",
              time: "2h ago",
              image: AppImages.companyProfile2,
              isUnread: true,
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 48),
            _buildNotificationItem(
              context,
              name: "Ally Wales",
              action: "Send you a message",
              time: "9h ago",
              image: AppImages.companyProfile3,
              isUnread: true,
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 48),

            // This Week Section
            Text(
              t.tr(en: "This Week", ar: "هذا الأسبوع"),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildNotificationItem(
              context,
              name: "Ruben Culhane",
              action: "Liked your posted",
              time: "2D ago",
              image: AppImages.companyProfile6,
              isUnread: true,
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 48),
            _buildNotificationItem(
              context,
              name: "Warren Buffet",
              action: "Liked your posted",
              time: "6D ago",
              initials: "WA",
              isUnread: true,
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 48),
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
