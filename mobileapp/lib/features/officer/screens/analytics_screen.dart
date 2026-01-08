import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/dummy_data.dart';
import '../../../providers/complaint_provider.dart';
import '../widgets/stats_card.dart';

/// Officer analytics screen with performance metrics
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = DummyData.officerStats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
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
            // Performance summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
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
                              const SizedBox(height: 4),
                              Text(
                                'Based on resolution time & ratings',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${stats['performanceScore']}%',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
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
            ),
            const SizedBox(height: 24),

            // Key metrics
            Text(
              'Key Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    icon: Icons.timer_outlined,
                    title: 'Avg Response',
                    value: '${stats['avgResponseTime']}h',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    icon: Icons.star_outline,
                    title: 'Avg Rating',
                    value: stats['rating'].toString(),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    icon: Icons.check_circle_outline,
                    title: 'Resolved',
                    value: stats['completed'].toString(),
                    color: AppColors.info,
                    trend: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    icon: Icons.pending_actions,
                    title: 'Pending',
                    value: stats['pending'].toString(),
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly breakdown
            Text(
              'This Week',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _MetricRow(label: 'Issues Assigned', value: '12'),
                    const Divider(),
                    _MetricRow(label: 'Issues Resolved', value: '9'),
                    const Divider(),
                    _MetricRow(label: 'Average Response Time', value: '2.3 hours'),
                    const Divider(),
                    _MetricRow(label: 'Citizen Satisfaction', value: '4.7/5'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Performance breakdown by category
            Text(
              'By Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _CategoryProgress(label: 'Roads & Potholes', value: 0.85, count: 15),
            _CategoryProgress(label: 'Garbage & Waste', value: 0.72, count: 8),
            _CategoryProgress(label: 'Street Lights', value: 0.91, count: 6),
            _CategoryProgress(label: 'Drainage', value: 0.68, count: 4),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  final String label;
  final double value;
  final int count;

  const _CategoryProgress({
    required this.label,
    required this.value,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '$count resolved',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(
                  value > 0.8
                      ? AppColors.severityLow
                      : value > 0.6
                          ? AppColors.severityMedium
                          : AppColors.severityHigh,
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
