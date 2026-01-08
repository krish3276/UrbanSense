import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';

/// Reusable complaint card widget
class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback? onTap;

  const ComplaintCard({
    super.key,
    required this.complaint,
    this.onTap,
  });

  Color _getSeverityColor() {
    switch (complaint.severity) {
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

  Color _getStatusColor() {
    switch (complaint.status) {
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

  IconData _getIssueIcon() {
    switch (complaint.issueType) {
      case 'Road Damage':
        return Icons.warning_rounded;
      case 'Street Light':
        return Icons.lightbulb_outline_rounded;
      case 'Garbage':
        return Icons.delete_outline_rounded;
      case 'Water Leakage':
        return Icons.water_drop_outlined;
      case 'Sewage':
        return Icons.plumbing_rounded;
      case 'Traffic Signal':
        return Icons.traffic_rounded;
      case 'Illegal Construction':
        return Icons.domain_disabled_rounded;
      default:
        return Icons.report_problem_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Issue icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getSeverityColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIssueIcon(),
                      color: _getSeverityColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          complaint.issueType,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      complaint.status.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      complaint.location,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Bottom row with severity and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Severity badge
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getSeverityColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${complaint.severity.displayName} Priority',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getSeverityColor(),
                        ),
                      ),
                    ],
                  ),
                  // Date
                  Text(
                    _formatDate(complaint.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
