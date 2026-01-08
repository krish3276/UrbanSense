import 'package:flutter/foundation.dart';
import '../models/complaint_model.dart';
import '../models/dummy_data.dart';

/// Provider for managing complaints
class ComplaintProvider extends ChangeNotifier {
  List<ComplaintModel> _complaints = [];
  ComplaintModel? _selectedComplaint;
  bool _isLoading = false;

  List<ComplaintModel> get complaints => _complaints;
  ComplaintModel? get selectedComplaint => _selectedComplaint;
  bool get isLoading => _isLoading;

  ComplaintProvider() {
    _loadComplaints();
  }

  /// Load complaints from dummy data
  void _loadComplaints() {
    _complaints = List.from(DummyData.complaints);
    notifyListeners();
  }

  /// Get citizen's complaints
  List<ComplaintModel> getCitizenComplaints() {
    return _complaints.where((c) => c.citizenId == 'citizen_001').toList();
  }

  /// Get officer's assigned complaints
  List<ComplaintModel> getOfficerComplaints({String? department}) {
    return _complaints.where((c) {
      final isAssigned = c.assignedOfficerId == 'officer_001' &&
          (c.status == ComplaintStatus.inProgress ||
              c.status == ComplaintStatus.submitted);
      
      if (department != null) {
        return isAssigned && c.assignedDepartment == department;
      }
      return isAssigned;
    }).toList();
  }

  /// Get completed complaints for officer
  List<ComplaintModel> getCompletedComplaints() {
    return _complaints.where((c) =>
        c.assignedOfficerId == 'officer_001' &&
        (c.status == ComplaintStatus.resolved ||
            c.status == ComplaintStatus.closed)).toList();
  }

  /// Get complaints by status
  List<ComplaintModel> getByStatus(ComplaintStatus status) {
    return _complaints.where((c) => c.status == status).toList();
  }

  /// Get complaints by severity
  List<ComplaintModel> getBySeverity(SeverityLevel severity) {
    return _complaints.where((c) => c.severity == severity).toList();
  }

  /// Select a complaint for viewing
  void selectComplaint(ComplaintModel complaint) {
    _selectedComplaint = complaint;
    notifyListeners();
  }

  /// Add a new complaint (mock)
  Future<ComplaintModel> addComplaint({
    required String title,
    required String description,
    required String issueType,
    required String location,
    String? department,
    SeverityLevel? severity,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final newComplaint = ComplaintModel(
      id: 'CMP${_complaints.length + 1}'.padLeft(6, '0'),
      title: title,
      description: description,
      issueType: issueType,
      severity: severity ?? SeverityLevel.medium, // Will be set by AI analysis
      status: ComplaintStatus.submitted,
      location: location,
      latitude: 23.0225,
      longitude: 72.5714,
      createdAt: DateTime.now(),
      citizenId: 'citizen_001',
      citizenName: 'Rahul Sharma',
      assignedDepartment: department,
      timeline: [
        StatusUpdate(
          id: 'SU${DateTime.now().millisecondsSinceEpoch}',
          status: ComplaintStatus.submitted,
          message: 'Complaint submitted successfully',
          timestamp: DateTime.now(),
        ),
      ],
    );

    _complaints.insert(0, newComplaint);
    _isLoading = false;
    notifyListeners();
    return newComplaint;
  }

  /// Update complaint status (for officers)
  Future<void> updateComplaintStatus(
    String complaintId,
    ComplaintStatus newStatus,
    String message,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      final complaint = _complaints[index];
      final newTimeline = List<StatusUpdate>.from(complaint.timeline);
      newTimeline.add(StatusUpdate(
        id: 'SU${DateTime.now().millisecondsSinceEpoch}',
        status: newStatus,
        message: message,
        timestamp: DateTime.now(),
        updatedBy: 'Amit Kumar',
      ));

      _complaints[index] = complaint.copyWith(
        status: newStatus,
        timeline: newTimeline,
        resolvedAt: newStatus == ComplaintStatus.resolved ? DateTime.now() : null,
      );

      if (_selectedComplaint?.id == complaintId) {
        _selectedComplaint = _complaints[index];
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Submit feedback for a resolved complaint
  Future<void> submitFeedback(
    String complaintId,
    double rating,
    String feedback,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      _complaints[index] = _complaints[index].copyWith(
        rating: rating,
        feedback: feedback,
        status: ComplaintStatus.closed,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Get complaint by ID
  ComplaintModel? getComplaintById(String id) {
    try {
      return _complaints.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get complaints by department (for admin)
  List<ComplaintModel> getComplaintsByDepartment(String department) {
    return _complaints.where((c) => c.assignedDepartment == department).toList();
  }

  /// Clear selection
  void clearSelection() {
    _selectedComplaint = null;
    notifyListeners();
  }
}
