import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';
import '../../../providers/complaint_provider.dart';

/// Modern complaint tracking screen with app theme colors
class ComplaintTrackingScreen extends StatelessWidget {
  final String complaintId;

  const ComplaintTrackingScreen({super.key, required this.complaintId});

  Color _getSeverityColor(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.low:
        return AppColors.severityLow;
      case SeverityLevel.medium:
        return AppColors.severityMedium;
      case SeverityLevel.high:
        return AppColors.severityHigh;
      case SeverityLevel.critical:
        return AppColors.severityCritical;
    }
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return AppColors.statusSubmitted;
      case ComplaintStatus.inProgress:
        return AppColors.statusInProgress;
      case ComplaintStatus.resolved:
        return AppColors.statusResolved;
      case ComplaintStatus.closed:
        return AppColors.statusClosed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track Complaint'),
        leading: IconButton(
          onPressed: () => context.go('/citizen'),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality')),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Consumer<ComplaintProvider>(
        builder: (context, provider, child) {
          final complaint = provider.getComplaintById(complaintId);
          
          if (complaint == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'Complaint not found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern header card with ID and status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getStatusIcon(complaint.status),
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Complaint #${complaint.id}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    complaint.status.displayName.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.black.withOpacity(0.2), height: 1),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoItem(
                              icon: Icons.calendar_today,
                              label: 'Submitted',
                              value: _formatDate(complaint.createdAt),
                            ),
                          ),
                          if (complaint.estimatedResolutionTime != null) ...[
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _InfoItem(
                                icon: Icons.schedule,
                                label: 'ETA',
                                value: complaint.estimatedResolutionTime!,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Issue details card
                _SectionHeader(title: 'Issue Details'),
                const SizedBox(height: 12),
                Card(
                  color: AppColors.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppColors.surfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    complaint.title,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.category,
                                        size: 14,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        complaint.issueType,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getSeverityColor(complaint.severity).withOpacity(0.2),
                                    _getSeverityColor(complaint.severity).withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getSeverityColor(complaint.severity),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    size: 16,
                                    color: _getSeverityColor(complaint.severity),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    complaint.severity.displayName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getSeverityColor(complaint.severity),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          complaint.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  complaint.location,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Assigned department
                if (complaint.assignedDepartment != null) ...[
                  _SectionHeader(title: 'Assigned To'),
                  const SizedBox(height: 12),
                  Card(
                    color: AppColors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.surfaceVariant,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary.withOpacity(0.2),
                                  AppColors.secondary.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.business,
                              color: AppColors.secondary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  complaint.assignedDepartment!,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (complaint.assignedOfficerName != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        complaint.assignedOfficerName!,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Call functionality')),
                              );
                            },
                            icon: Icon(Icons.phone, color: AppColors.primary),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary.withOpacity(0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Timeline
                _SectionHeader(title: 'Status Timeline'),
                const SizedBox(height: 12),
                Card(
                  color: AppColors.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppColors.surfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: List.generate(
                        complaint.timeline.length,
                        (index) {
                          final update = complaint.timeline[complaint.timeline.length - 1 - index];
                          final isFirst = index == 0;
                          final isLast = index == complaint.timeline.length - 1;
                          
                          return _TimelineItem(
                            status: update.status,
                            message: update.message,
                            timestamp: update.timestamp,
                            updatedBy: update.updatedBy,
                            isFirst: isFirst,
                            isLast: isLast,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action button
                if (complaint.status == ComplaintStatus.resolved)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/citizen/feedback/${complaint.id}'),
                      icon: const Icon(Icons.star_outline, size: 22),
                      label: const Text('Give Feedback'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact support')),
                        );
                      },
                      icon: const Icon(Icons.support_agent, size: 22),
                      label: const Text('Contact Support'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return Icons.upload_file;
      case ComplaintStatus.inProgress:
        return Icons.pending_actions;
      case ComplaintStatus.resolved:
        return Icons.check_circle;
      case ComplaintStatus.closed:
        return Icons.verified;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black.withOpacity(0.7), size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ComplaintStatus status;
  final String message;
  final DateTime timestamp;
  final String? updatedBy;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.status,
    required this.message,
    required this.timestamp,
    this.updatedBy,
    required this.isFirst,
    required this.isLast,
  });

  Color _getStatusColor() {
    switch (status) {
      case ComplaintStatus.submitted:
        return AppColors.statusSubmitted;
      case ComplaintStatus.inProgress:
        return AppColors.statusInProgress;
      case ComplaintStatus.resolved:
        return AppColors.statusResolved;
      case ComplaintStatus.closed:
        return AppColors.statusClosed;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case ComplaintStatus.submitted:
        return Icons.upload_file;
      case ComplaintStatus.inProgress:
        return Icons.pending_actions;
      case ComplaintStatus.resolved:
        return Icons.check_circle;
      case ComplaintStatus.closed:
        return Icons.verified;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isFirst
                      ? AppColors.primary
                      : _getStatusColor().withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFirst ? AppColors.primaryDark : _getStatusColor(),
                    width: 2,
                  ),
                  boxShadow: isFirst
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(),
                    color: isFirst ? Colors.black : _getStatusColor(),
                    size: isFirst ? 22 : 18,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getStatusColor().withOpacity(0.4),
                          AppColors.surfaceVariant,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
                          color: isFirst ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textHint,
                              fontSize: 12,
                            ),
                      ),
                      if (updatedBy != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.person_outline,
                          size: 13,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          updatedBy!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
