import 'package:flutter/material.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../data/models/notification/notification_models.dart';
import '../../../data/services/notification_service.dart';
import '../../../core/network/api_client.dart';

class CompanyNotificationsScreen extends StatefulWidget {
  const CompanyNotificationsScreen({super.key});

  @override
  State<CompanyNotificationsScreen> createState() =>
      _CompanyNotificationsScreenState();
}

class _CompanyNotificationsScreenState
    extends State<CompanyNotificationsScreen> {
  late final NotificationService _notificationService;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use the initialized instance if possible, or fallback to ApiClient
    try {
      _notificationService = NotificationService.instance;
    } catch (_) {
      _notificationService = NotificationService(ApiClient());
    }
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final data = await _notificationService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = data;
          // Sort newest first
          _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      setState(() {
        _notifications = _notifications.map((n) {
          return AppNotification(
            id: n.id,
            title: n.title,
            body: n.body,
            type: n.type,
            isRead: true,
            createdAt: n.createdAt,
            data: n.data,
          );
        }).toList();
      });
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _markAsRead(String id) async {
    try {
      await _notificationService.markAsRead(id);
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == id);
        if (index != -1) {
          final n = _notifications[index];
          _notifications[index] = AppNotification(
            id: n.id,
            title: n.title,
            body: n.body,
            type: n.type,
            isRead: true,
            createdAt: n.createdAt,
            data: n.data,
          );
        }
      });
    } catch (e) {
      // Ignore
    }
  }

  String _formatTime(DateTime date, bool isAr) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours > 0)
        return isAr ? 'منذ ${diff.inHours} ساعة' : '${diff.inHours}h ago';
      if (diff.inMinutes > 0)
        return isAr ? 'منذ ${diff.inMinutes} دقيقة' : '${diff.inMinutes}m ago';
      return isAr ? 'الآن' : 'Just now';
    }
    if (diff.inDays < 7) {
      return isAr ? 'منذ ${diff.inDays} أيام' : '${diff.inDays}d ago';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: t.tr(en: 'Notifications', ar: 'الإشعارات'),
      showBack: true,
      actions: [
        if (_notifications.any((n) => !n.isRead))
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              t.tr(en: 'Mark all as read', ar: 'تحديد الكل كمقروء'),
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
            ),
          ),
      ],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: cs.onSurface.withOpacity(0.12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.tr(en: "No notifications yet", ar: "لا توجد إشعارات بعد"),
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.38),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final n = _notifications[index];
                  return Container(
                    color: n.isRead
                        ? Colors.transparent
                        : cs.primaryContainer.withOpacity(0.2),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: n.isRead
                            ? cs.surfaceContainerHighest
                            : cs.primary,
                        child: Icon(
                          _getIconForType(n.type),
                          color: n.isRead ? cs.onSurfaceVariant : cs.onPrimary,
                        ),
                      ),
                      title: Text(
                        n.title,
                        style: TextStyle(
                          fontWeight: n.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            n.body,
                            style: TextStyle(
                              color: cs.onSurface.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatTime(n.createdAt, t.isAr),
                            style: TextStyle(
                              color: cs.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (!n.isRead) _markAsRead(n.id);
                        // TODO: Handle navigation if payload data exists
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'job_application':
        return Icons.work_outline;
      case 'message':
        return Icons.chat_bubble_outline;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications_active_outlined;
    }
  }
}
