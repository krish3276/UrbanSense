/// Complaint status enum
enum ComplaintStatus {
  submitted,
  inProgress,
  resolved,
  closed;

  String get displayName {
    switch (this) {
      case ComplaintStatus.submitted:
        return 'Submitted';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.closed:
        return 'Closed';
    }
  }
}

/// Severity level enum
enum SeverityLevel {
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case SeverityLevel.low:
        return 'Low';
      case SeverityLevel.medium:
        return 'Medium';
      case SeverityLevel.high:
        return 'High';
      case SeverityLevel.critical:
        return 'Critical';
    }
  }
}

/// Status update in timeline
class StatusUpdate {
  final String id;
  final ComplaintStatus status;
  final String message;
  final DateTime timestamp;
  final String? updatedBy;

  const StatusUpdate({
    required this.id,
    required this.status,
    required this.message,
    required this.timestamp,
    this.updatedBy,
  });
}

/// Main complaint model
class ComplaintModel {
  final String id;
  final String title;
  final String description;
  final String issueType;
  final SeverityLevel severity;
  final ComplaintStatus status;
  final String location;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? assignedOfficerId;
  final String? assignedOfficerName;
  final String? assignedDepartment;
  final String? imageUrl;
  final String? voiceNoteUrl;
  final String? resolutionProofUrl;
  final String citizenId;
  final String citizenName;
  final List<StatusUpdate> timeline;
  final String? estimatedResolutionTime;
  final double? rating;
  final String? feedback;

  const ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    required this.issueType,
    required this.severity,
    required this.status,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.resolvedAt,
    this.assignedOfficerId,
    this.assignedOfficerName,
    this.assignedDepartment,
    this.imageUrl,
    this.voiceNoteUrl,
    this.resolutionProofUrl,
    required this.citizenId,
    required this.citizenName,
    required this.timeline,
    this.estimatedResolutionTime,
    this.rating,
    this.feedback,
  });

  ComplaintModel copyWith({
    String? id,
    String? title,
    String? description,
    String? issueType,
    SeverityLevel? severity,
    ComplaintStatus? status,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? resolvedAt,
    String? assignedOfficerId,
    String? assignedOfficerName,
    String? assignedDepartment,
    String? imageUrl,
    String? voiceNoteUrl,
    String? resolutionProofUrl,
    String? citizenId,
    String? citizenName,
    List<StatusUpdate>? timeline,
    String? estimatedResolutionTime,
    double? rating,
    String? feedback,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      issueType: issueType ?? this.issueType,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      assignedOfficerId: assignedOfficerId ?? this.assignedOfficerId,
      assignedOfficerName: assignedOfficerName ?? this.assignedOfficerName,
      assignedDepartment: assignedDepartment ?? this.assignedDepartment,
      imageUrl: imageUrl ?? this.imageUrl,
      voiceNoteUrl: voiceNoteUrl ?? this.voiceNoteUrl,
      resolutionProofUrl: resolutionProofUrl ?? this.resolutionProofUrl,
      citizenId: citizenId ?? this.citizenId,
      citizenName: citizenName ?? this.citizenName,
      timeline: timeline ?? this.timeline,
      estimatedResolutionTime: estimatedResolutionTime ?? this.estimatedResolutionTime,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
    );
  }
}
