import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';
import '../../../models/dummy_data.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/complaint_provider.dart';
import '../widgets/priority_chip.dart';
import '../widgets/stats_card.dart';
import 'officer_map_screen.dart';

/// Officer dashboard screen
class OfficerDashboardScreen extends StatefulWidget {
  const OfficerDashboardScreen({super.key});

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
  int _currentIndex = 0;
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _DashboardTab(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
          ),
          const _MapTab(),
          const _ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _DashboardTab({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final stats = DummyData.officerStats;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'O',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${user?.name.split(' ').first ?? 'Officer'}!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.info,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'On Duty',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.push('/officer/notifications'),
                  icon: const Badge(
                    label: Text('1'),
                    child: Icon(Icons.notifications_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats overview
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    icon: Icons.assignment,
                    title: 'Assigned',
                    value: stats['totalAssigned'].toString(),
                    color: AppColors.primary,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    icon: Icons.pending_actions,
                    title: 'Pending',
                    value: stats['pending'].toString(),
                    color: AppColors.info,
                    isCompact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    icon: Icons.check_circle,
                    title: 'Completed',
                    value: stats['completed'].toString(),
                    color: AppColors.info,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    icon: Icons.star,
                    title: 'Rating',
                    value: stats['rating'].toString(),
                    color: AppColors.primary,
                    isCompact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Assigned complaints
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned Complaints',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => context.push('/officer/history'),
                  child: const Text('History'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Critical', 'High', 'Medium', 'Low'].map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) => onFilterChanged(filter),
                      backgroundColor: AppColors.surfaceVariant,
                      selectedColor: _getFilterColor(filter).withOpacity(0.2),
                      checkmarkColor: _getFilterColor(filter),
                      labelStyle: TextStyle(
                        color: isSelected ? _getFilterColor(filter) : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Complaints list
            Consumer<ComplaintProvider>(
              builder: (context, provider, child) {
                // Get officer's department from user profile
                final department = user?.department;
                
                // Filter by department if specified
                var complaints = department != null
                    ? provider.getOfficerComplaints(department: department)
                    : provider.getOfficerComplaints();
                
                // Apply filter
                if (selectedFilter != 'All') {
                  final severity = SeverityLevel.values.firstWhere(
                    (s) => s.displayName == selectedFilter,
                    orElse: () => SeverityLevel.medium,
                  );
                  complaints = complaints.where((c) => c.severity == severity).toList();
                }

                // Sort by severity (critical first)
                complaints.sort((a, b) => b.severity.index.compareTo(a.severity.index));

                if (complaints.isEmpty) {
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
                            'No pending complaints',
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
                  children: complaints.map((complaint) {
                    return _ComplaintCard(
                      complaint: complaint,
                      onTap: () => context.push('/officer/issue/${complaint.id}'),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Critical':
        return AppColors.severityCritical;
      case 'High':
        return AppColors.severityHigh;
      case 'Medium':
        return AppColors.severityMedium;
      case 'Low':
        return AppColors.severityLow;
      default:
        return AppColors.primary;
    }
  }
}

class _MapTab extends StatelessWidget {
  const _MapTab();

  @override
  Widget build(BuildContext context) {
    return const OfficerMapScreen();
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final stats = DummyData.officerStats;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? 'O',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Officer',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Municipal Officer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified,
                    size: 16,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Verified Officer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Performance card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Score',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${stats['performanceScore']}%',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: stats['performanceScore'] / 100,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Menu items
            _ProfileMenuItem(
              icon: Icons.history,
              title: 'Work History',
              onTap: () => context.push('/officer/history'),
            ),
            _ProfileMenuItem(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              onTap: () => context.push('/officer/analytics'),
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => context.push('/officer/notifications'),
            ),
            _ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => context.push('/officer/settings'),
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () => context.push('/officer/help'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.severityCritical,
                  side: const BorderSide(color: AppColors.severityCritical),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback onTap;

  const _ComplaintCard({required this.complaint, required this.onTap});

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
                  PriorityChip(severity: complaint.severity),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      complaint.status.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(complaint.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                complaint.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                complaint.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      complaint.location,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendItem({required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
