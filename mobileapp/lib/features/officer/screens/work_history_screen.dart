import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';
import '../../../models/dummy_data.dart';
import '../../../providers/complaint_provider.dart';
import '../widgets/priority_chip.dart';
import '../widgets/stats_card.dart';

/// Work history screen for officers
class WorkHistoryScreen extends StatelessWidget {
  const WorkHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = DummyData.officerStats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work History'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Performance overview
            Text(
              'Performance Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Performance score card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Performance Score',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${stats['performanceScore']}',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, left: 4),
                                child: Text(
                                  '/100',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: stats['performanceScore'] / 100,
                              backgroundColor: AppColors.surfaceVariant,
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: AppColors.primary,
                            size: 40,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Excellent',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    icon: Icons.check_circle,
                    title: 'Total Completed',
                    value: stats['completed'].toString(),
                    color: AppColors.info,
                    trend: 15,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    icon: Icons.star,
                    title: 'Avg Rating',
                    value: stats['rating'].toString(),
                    color: AppColors.primary,
                    trend: 8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    icon: Icons.timer,
                    title: 'Avg Resolution',
                    value: stats['avgResolutionTime'],
                    color: AppColors.primary,
                    trend: -12,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    icon: Icons.calendar_month,
                    title: 'This Month',
                    value: stats['thisMonth'].toString(),
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Completed tasks
            Text(
              'Completed Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            Consumer<ComplaintProvider>(
              builder: (context, provider, child) {
                final completedComplaints = provider.getCompletedComplaints();

                if (completedComplaints.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No completed tasks yet',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: completedComplaints.map((complaint) {
                    return _CompletedTaskCard(complaint: complaint);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedTaskCard extends StatelessWidget {
  final ComplaintModel complaint;

  const _CompletedTaskCard({required this.complaint});

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.severityLow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.severityLow,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        complaint.issueType,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        complaint.status.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                    if (complaint.rating != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.severityMedium),
                          const SizedBox(width: 2),
                          Text(
                            complaint.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.severityMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PriorityChip(severity: complaint.severity, showLabel: false),
                    const SizedBox(width: 8),
                    Text(
                      'Resolved ${_formatDate(complaint.resolvedAt ?? complaint.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textHint,
                          ),
                    ),
                  ],
                ),
                if (complaint.feedback != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.feedback_outlined, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Has Feedback',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
