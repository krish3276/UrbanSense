/// Notification model for status updates
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? complaintId;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.complaintId,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? complaintId,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      complaintId: complaintId ?? this.complaintId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}

/// Notification type enum
enum NotificationType {
  statusUpdate,
  assignment,
  resolution,
  feedback,
  general;

  String get displayName {
    switch (this) {
      case NotificationType.statusUpdate:
        return 'Status Update';
      case NotificationType.assignment:
        return 'Assignment';
      case NotificationType.resolution:
        return 'Resolution';
      case NotificationType.feedback:
        return 'Feedback';
      case NotificationType.general:
        return 'General';
    }
  }
}
