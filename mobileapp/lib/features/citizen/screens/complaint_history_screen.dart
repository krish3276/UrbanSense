import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../providers/complaint_provider.dart';
import '../widgets/complaint_card.dart';

/// Complaint history screen showing all past complaints
class ComplaintHistoryScreen extends StatefulWidget {
  const ComplaintHistoryScreen({super.key});

  @override
  State<ComplaintHistoryScreen> createState() => _ComplaintHistoryScreenState();
}

class _ComplaintHistoryScreenState extends State<ComplaintHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint History'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() => _selectedFilter = value),
            itemBuilder: (context) => [
              _buildFilterItem('All', Icons.list),
              _buildFilterItem('Resolved', Icons.check_circle_outline),
              _buildFilterItem('In Progress', Icons.pending_outlined),
              _buildFilterItem('Submitted', Icons.upload_outlined),
            ],
          ),
        ],
      ),
      body: Consumer<ComplaintProvider>(
        builder: (context, provider, child) {
          var complaints = provider.getCitizenComplaints();
          
          // Apply filter
          if (_selectedFilter != 'All') {
            complaints = complaints.where((c) {
              return c.status.displayName == _selectedFilter;
            }).toList();
          }

          if (complaints.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFilter == 'All' 
                        ? 'No complaints yet' 
                        : 'No $_selectedFilter complaints',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your complaint history will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Stats bar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: 'Total',
                      value: provider.getCitizenComplaints().length.toString(),
                      color: AppColors.primary,
                    ),
                    _StatItem(
                      label: 'Resolved',
                      value: provider.getCitizenComplaints()
                          .where((c) => c.status.displayName == 'Resolved')
                          .length
                          .toString(),
                      color: AppColors.severityLow,
                    ),
                    _StatItem(
                      label: 'Pending',
                      value: provider.getCitizenComplaints()
                          .where((c) => c.status.displayName != 'Resolved' && 
                                       c.status.displayName != 'Closed')
                          .length
                          .toString(),
                      color: AppColors.severityMedium,
                    ),
                  ],
                ),
              ),
              // Filter indicator
              if (_selectedFilter != 'All')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Showing: $_selectedFilter',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setState(() => _selectedFilter = 'All'),
                        child: const Text('Clear filter'),
                      ),
                    ],
                  ),
                ),
              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return ComplaintCard(
                      complaint: complaint,
                      onTap: () => context.push('/citizen/tracking/${complaint.id}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PopupMenuItem<String> _buildFilterItem(String value, IconData icon) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(value),
          if (_selectedFilter == value) ...[
            const Spacer(),
            const Icon(Icons.check, size: 18, color: AppColors.primary),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
