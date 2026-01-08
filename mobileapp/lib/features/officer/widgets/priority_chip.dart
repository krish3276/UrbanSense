import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';

/// Priority chip widget for officer screens
class PriorityChip extends StatelessWidget {
  final SeverityLevel severity;
  final bool showLabel;

  const PriorityChip({
    super.key,
    required this.severity,
    this.showLabel = true,
  });

  Color _getColor() {
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

  IconData _getIcon() {
    switch (severity) {
      case SeverityLevel.low:
        return Icons.arrow_downward;
      case SeverityLevel.medium:
        return Icons.remove;
      case SeverityLevel.high:
        return Icons.arrow_upward;
      case SeverityLevel.critical:
        return Icons.priority_high;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? 10 : 6,
        vertical: showLabel ? 4 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 14, color: color),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              severity.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
