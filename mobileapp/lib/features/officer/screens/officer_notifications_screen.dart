import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../models/dummy_data.dart';

/// Officer notifications screen
class OfficerNotificationsScreen extends StatefulWidget {
  const OfficerNotificationsScreen({super.key});

  @override
  State<OfficerNotificationsScreen> createState() => _OfficerNotificationsScreenState();
}

class _OfficerNotificationsScreenState extends State<OfficerNotificationsScreen> {
  final List<_OfficerNotification> _notifications = [
    _OfficerNotification(
      id: '1',
      title: 'New Critical Issue Assigned',
      message: 'A critical pothole issue at MG Road has been assigned to you.',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      type: _NotificationType.critical,
      isRead: false,
    ),
    _OfficerNotification(
      id: '2',
      title: 'Status Update Reminder',
      message: 'Please update the status for issue #URB-2024-006.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: _NotificationType.reminder,
      isRead: false,
    ),
    _OfficerNotification(
      id: '3',
      title: 'Great Rating!',
      message: 'You received a 5-star rating for issue #URB-2024-004.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      type: _NotificationType.rating,
      isRead: true,
    ),
    _OfficerNotification(
      id: '4',
      title: 'New Issue Assigned',
      message: 'A new street light issue at Navrangpura has been assigned.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: _NotificationType.assignment,
      isRead: true,
    ),
    _OfficerNotification(
      id: '5',
      title: 'Weekly Report Available',
      message: 'Your performance report for this week is ready to view.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: _NotificationType.report,
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _NotificationTile(
                  notification: notification,
                  onTap: () {
                    setState(() {
                      notification.isRead = true;
                    });
                  },
                );
              },
            ),
    );
  }
}

enum _NotificationType { critical, reminder, rating, assignment, report }

class _OfficerNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final _NotificationType type;
  bool isRead;

  _OfficerNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}

class _NotificationTile extends StatelessWidget {
  final _OfficerNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  IconData _getIcon() {
    switch (notification.type) {
      case _NotificationType.critical:
        return Icons.warning_amber;
      case _NotificationType.reminder:
        return Icons.schedule;
      case _NotificationType.rating:
        return Icons.star;
      case _NotificationType.assignment:
        return Icons.assignment;
      case _NotificationType.report:
        return Icons.assessment;
    }
  }

  Color _getColor() {
    switch (notification.type) {
      case _NotificationType.critical:
        return AppColors.severityCritical;
      case _NotificationType.reminder:
        return AppColors.severityMedium;
      case _NotificationType.rating:
        return AppColors.severityLow;
      case _NotificationType.assignment:
        return AppColors.secondary;
      case _NotificationType.report:
        return AppColors.primary;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead ? null : AppColors.secondary.withOpacity(0.05),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_getIcon(), color: _getColor()),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.time),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textHint,
                  ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
