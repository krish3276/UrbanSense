import 'complaint_model.dart';
import 'notification_model.dart';
import 'user_model.dart';

/// Dummy data for the app
class DummyData {
  // Officer mobile numbers for auto role detection
  // Format: 'mobile' -> {'name', 'department', 'id'}
  static const Map<String, Map<String, String>> officerNumbers = {
    '9876512345': {
      'name': 'Amit Kumar',
      'department': 'Public Works',
      'id': 'officer_001',
    },
    '9876512346': {
      'name': 'Priya Patel',
      'department': 'Sanitation',
      'id': 'officer_002',
    },
    '9876512347': {
      'name': 'Rajesh Singh',
      'department': 'Electrical',
      'id': 'officer_003',
    },
    '9876512348': {
      'name': 'Neha Sharma',
      'department': 'Water Supply',
      'id': 'officer_004',
    },
  };

  // Current logged in user (will be set based on mobile number)
  static UserModel currentCitizen = UserModel(
    id: 'citizen_001',
    name: 'Rahul Sharma',
    phone: '+91 98765 43210',
    email: 'rahul.sharma@email.com',
    role: UserRole.citizen,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    rank: 1250, // Contribution score
  );

  static UserModel currentOfficer = UserModel(
    id: 'officer_001',
    name: 'Amit Kumar',
    phone: '+91 98765 12345',
    email: 'amit.kumar@urbansense.gov',
    role: UserRole.officer,
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
    department: 'Public Works',
  );

  // List of complaints
  static List<ComplaintModel> complaints = [
    ComplaintModel(
      id: 'CMP001',
      title: 'Large Pothole on Main Road',
      description: 'There is a large pothole near the bus stop that is causing accidents. Multiple vehicles have been damaged.',
      issueType: 'Road Damage',
      severity: SeverityLevel.high,
      status: ComplaintStatus.inProgress,
      location: 'MG Road, Near City Mall',
      latitude: 23.0225,
      longitude: 72.5714,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      assignedOfficerId: 'officer_001',
      assignedOfficerName: 'Amit Kumar',
      assignedDepartment: 'Public Works',
      imageUrl: 'https://example.com/pothole.jpg',
      citizenId: 'citizen_001',
      citizenName: 'Rahul Sharma',
      estimatedResolutionTime: '2-3 days',
      timeline: [
        StatusUpdate(
          id: 'SU001',
          status: ComplaintStatus.submitted,
          message: 'Complaint submitted successfully',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
        StatusUpdate(
          id: 'SU002',
          status: ComplaintStatus.inProgress,
          message: 'Assigned to Public Works Department',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          updatedBy: 'System',
        ),
        StatusUpdate(
          id: 'SU003',
          status: ComplaintStatus.inProgress,
          message: 'Officer dispatched to location',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          updatedBy: 'Amit Kumar',
        ),
      ],
    ),
    ComplaintModel(
      id: 'CMP002',
      title: 'Street Light Not Working',
      description: 'The street light at the corner of Park Street has not been working for a week. The area is very dark at night.',
      issueType: 'Street Light',
      severity: SeverityLevel.medium,
      status: ComplaintStatus.submitted,
      location: 'Park Street, Sector 12',
      latitude: 23.0300,
      longitude: 72.5800,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      citizenId: 'citizen_001',
      citizenName: 'Rahul Sharma',
      timeline: [
        StatusUpdate(
          id: 'SU004',
          status: ComplaintStatus.submitted,
          message: 'Complaint submitted successfully',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    ComplaintModel(
      id: 'CMP003',
      title: 'Garbage Overflow',
      description: 'The garbage bin near the market is overflowing. It has not been cleared for 3 days and is causing a bad smell.',
      issueType: 'Garbage',
      severity: SeverityLevel.high,
      status: ComplaintStatus.resolved,
      location: 'Central Market, Block A',
      latitude: 23.0150,
      longitude: 72.5650,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      resolvedAt: DateTime.now().subtract(const Duration(days: 2)),
      assignedOfficerId: 'officer_002',
      assignedOfficerName: 'Priya Patel',
      assignedDepartment: 'Sanitation',
      citizenId: 'citizen_002',
      citizenName: 'Sneha Gupta',
      rating: 4.5,
      feedback: 'Quick response and good service!',
      timeline: [
        StatusUpdate(
          id: 'SU005',
          status: ComplaintStatus.submitted,
          message: 'Complaint submitted successfully',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
        ),
        StatusUpdate(
          id: 'SU006',
          status: ComplaintStatus.inProgress,
          message: 'Sanitation team notified',
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
        ),
        StatusUpdate(
          id: 'SU007',
          status: ComplaintStatus.resolved,
          message: 'Garbage cleared and area cleaned',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          updatedBy: 'Priya Patel',
        ),
      ],
    ),
    ComplaintModel(
      id: 'CMP004',
      title: 'Water Pipeline Leakage',
      description: 'Major water leakage on the main pipeline. Water is flooding the street and causing traffic issues.',
      issueType: 'Water Leakage',
      severity: SeverityLevel.critical,
      status: ComplaintStatus.inProgress,
      location: 'Industrial Area, Phase 2',
      latitude: 23.0400,
      longitude: 72.5900,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      assignedOfficerId: 'officer_001',
      assignedOfficerName: 'Amit Kumar',
      assignedDepartment: 'Water Supply',
      citizenId: 'citizen_003',
      citizenName: 'Vikram Singh',
      estimatedResolutionTime: '4-6 hours',
      timeline: [
        StatusUpdate(
          id: 'SU008',
          status: ComplaintStatus.submitted,
          message: 'Urgent complaint submitted',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        StatusUpdate(
          id: 'SU009',
          status: ComplaintStatus.inProgress,
          message: 'Emergency team dispatched',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ],
    ),
    ComplaintModel(
      id: 'CMP005',
      title: 'Broken Traffic Signal',
      description: 'Traffic signal at the main junction is not working. Causing major traffic jams during rush hours.',
      issueType: 'Traffic Signal',
      severity: SeverityLevel.high,
      status: ComplaintStatus.submitted,
      location: 'City Center Junction',
      latitude: 23.0180,
      longitude: 72.5720,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      citizenId: 'citizen_001',
      citizenName: 'Rahul Sharma',
      timeline: [
        StatusUpdate(
          id: 'SU010',
          status: ComplaintStatus.submitted,
          message: 'Complaint submitted successfully',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    ),
    ComplaintModel(
      id: 'CMP006',
      title: 'Illegal Construction',
      description: 'Unauthorized construction work happening without proper permissions. Blocking the public footpath.',
      issueType: 'Illegal Construction',
      severity: SeverityLevel.medium,
      status: ComplaintStatus.closed,
      location: 'Residential Colony, Block C',
      latitude: 23.0250,
      longitude: 72.5680,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      resolvedAt: DateTime.now().subtract(const Duration(days: 3)),
      assignedOfficerId: 'officer_001',
      assignedOfficerName: 'Amit Kumar',
      assignedDepartment: 'Building',
      citizenId: 'citizen_004',
      citizenName: 'Meera Joshi',
      rating: 5.0,
      feedback: 'Excellent work by the team. Issue resolved completely.',
      timeline: [
        StatusUpdate(
          id: 'SU011',
          status: ComplaintStatus.submitted,
          message: 'Complaint submitted',
          timestamp: DateTime.now().subtract(const Duration(days: 10)),
        ),
        StatusUpdate(
          id: 'SU012',
          status: ComplaintStatus.inProgress,
          message: 'Inspection scheduled',
          timestamp: DateTime.now().subtract(const Duration(days: 8)),
        ),
        StatusUpdate(
          id: 'SU013',
          status: ComplaintStatus.resolved,
          message: 'Construction stopped. Legal notice issued.',
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
        ),
        StatusUpdate(
          id: 'SU014',
          status: ComplaintStatus.closed,
          message: 'Case closed after verification',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
  ];

  // Notifications for citizen
  static List<NotificationModel> citizenNotifications = [
    NotificationModel(
      id: 'NOT001',
      title: 'Complaint Update',
      message: 'Your complaint about "Large Pothole on Main Road" has been assigned to an officer.',
      complaintId: 'CMP001',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: NotificationType.assignment,
    ),
    NotificationModel(
      id: 'NOT002',
      title: 'Status Update',
      message: 'Officer has been dispatched to inspect the pothole issue.',
      complaintId: 'CMP001',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      type: NotificationType.statusUpdate,
    ),
    NotificationModel(
      id: 'NOT003',
      title: 'New Complaint Registered',
      message: 'Your complaint "Street Light Not Working" has been successfully registered.',
      complaintId: 'CMP002',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.statusUpdate,
    ),
    NotificationModel(
      id: 'NOT004',
      title: 'Urgent Update',
      message: 'Traffic signal complaint has been registered as high priority.',
      complaintId: 'CMP005',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.statusUpdate,
    ),
  ];

  // Officer stats
  static Map<String, dynamic> officerStats = {
    'totalAssigned': 15,
    'completed': 12,
    'pending': 3,
    'avgResolutionTime': '2.5 days',
    'rating': 4.7,
    'thisMonth': 8,
    'performanceScore': 92,
  };

  // Get complaints assigned to officer
  static List<ComplaintModel> getOfficerComplaints() {
    return complaints.where((c) => 
      c.assignedOfficerId == 'officer_001' && 
      (c.status == ComplaintStatus.inProgress || c.status == ComplaintStatus.submitted)
    ).toList();
  }

  // Get citizen's complaints
  static List<ComplaintModel> getCitizenComplaints() {
    return complaints.where((c) => c.citizenId == 'citizen_001').toList();
  }

  // Get completed complaints for officer
  static List<ComplaintModel> getCompletedComplaints() {
    return complaints.where((c) => 
      c.assignedOfficerId == 'officer_001' && 
      (c.status == ComplaintStatus.resolved || c.status == ComplaintStatus.closed)
    ).toList();
  }

  // Get complaints by department
  static List<ComplaintModel> getComplaintsByDepartment(String department) {
    return complaints.where((c) => c.assignedDepartment == department).toList();
  }

  // Get today's complaints
  static List<ComplaintModel> getComplaintsToday() {
    final today = DateTime.now();
    return complaints.where((c) {
      final createdDate = c.createdAt;
      return createdDate.year == today.year &&
          createdDate.month == today.month &&
          createdDate.day == today.day;
    }).toList();
  }

  // Get average resolution time (mock calculation)
  static String getAverageResolutionTime() {
    final resolved = complaints.where((c) => c.resolvedAt != null).toList();
    if (resolved.isEmpty) return '0 days';
    
    int totalHours = 0;
    for (final complaint in resolved) {
      final duration = complaint.resolvedAt!.difference(complaint.createdAt);
      totalHours += duration.inHours;
    }
    final avgHours = totalHours ~/ resolved.length;
    final days = avgHours ~/ 24;
    final hours = avgHours % 24;
    
    if (days > 0) {
      return '$days day${days != 1 ? 's' : ''}';
    }
    return '$hours hour${hours != 1 ? 's' : ''}';
  }

  // Admin dashboard metrics
  static Map<String, dynamic> getAdminMetrics() {
    return {
      'totalComplaintsToday': getComplaintsToday().length,
      'totalComplaints': complaints.length,
      'averageResolutionTime': getAverageResolutionTime(),
      'departmentBreakdown': {
        'Public Works': complaints.where((c) => c.assignedDepartment == 'Public Works').length,
        'Sanitation': complaints.where((c) => c.assignedDepartment == 'Sanitation').length,
        'Water Supply': complaints.where((c) => c.assignedDepartment == 'Water Supply').length,
        'Electrical': complaints.where((c) => c.assignedDepartment == 'Electrical').length,
        'Traffic': complaints.where((c) => c.assignedDepartment == 'Traffic').length,
        'Building': complaints.where((c) => c.assignedDepartment == 'Building').length,
      },
      'statusBreakdown': {
        'Submitted': complaints.where((c) => c.status == ComplaintStatus.submitted).length,
        'In Progress': complaints.where((c) => c.status == ComplaintStatus.inProgress).length,
        'Resolved': complaints.where((c) => c.status == ComplaintStatus.resolved).length,
        'Closed': complaints.where((c) => c.status == ComplaintStatus.closed).length,
      },
    };
  }

  // Officer performance data for admin dashboard
  static List<Map<String, dynamic>> getOfficerPerformance() {
    return [
      {
        'id': 'officer_001',
        'name': 'Amit Kumar',
        'department': 'Public Works',
        'assignedCount': 15,
        'resolvedCount': 12,
        'avgResponseTime': '2.5 hours',
        'avgResolutionTime': '2.3 days',
        'rating': 4.7,
        'performanceScore': 92,
      },
      {
        'id': 'officer_002',
        'name': 'Priya Patel',
        'department': 'Sanitation',
        'assignedCount': 20,
        'resolvedCount': 18,
        'avgResponseTime': '1.8 hours',
        'avgResolutionTime': '1.5 days',
        'rating': 4.8,
        'performanceScore': 95,
      },
      {
        'id': 'officer_003',
        'name': 'Rajesh Singh',
        'department': 'Water Supply',
        'assignedCount': 12,
        'resolvedCount': 10,
        'avgResponseTime': '3.2 hours',
        'avgResolutionTime': '4.5 days',
        'rating': 4.5,
        'performanceScore': 88,
      },
      {
        'id': 'officer_004',
        'name': 'Sneha Desai',
        'department': 'Electrical',
        'assignedCount': 18,
        'resolvedCount': 16,
        'avgResponseTime': '2.1 hours',
        'avgResolutionTime': '1.8 days',
        'rating': 4.9,
        'performanceScore': 96,
      },
    ];
  }

  // AI Insights for admin
  static List<Map<String, dynamic>> getAIInsights() {
    return [
      {
        'type': 'recurring',
        'title': 'Recurring Issue Detected',
        'message': 'Main Street has reported 5 pothole-related complaints in the past 2 weeks',
        'priority': 'high',
        'icon': 'warning',
      },
      {
        'type': 'performance',
        'title': 'Performance Improvement',
        'message': 'Electrical department response time decreased by 15% this month',
        'priority': 'positive',
        'icon': 'trending_up',
      },
      {
        'type': 'trend',
        'title': 'Complaint Trend',
        'message': 'Water leakage complaints increased by 20% this week - possible infrastructure issue',
        'priority': 'medium',
        'icon': 'insights',
      },
      {
        'type': 'recommendation',
        'title': 'Resource Allocation',
        'message': 'Sanitation department may need 2 additional officers to handle increased workload',
        'priority': 'medium',
        'icon': 'people',
      },
    ];
  }
}
