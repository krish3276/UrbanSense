import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/complaint_model.dart';
import '../../../models/dummy_data.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/complaint_provider.dart';
import '../widgets/complaint_card.dart';
import '../widgets/map_placeholder.dart';
import '../widgets/nearby_map_widget.dart';

/// Citizen home dashboard screen
class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  int _currentIndex = 0;

  void _setTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _MyComplaintsTab(),
          _NearbyTab(),
          _ProfileTab(),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/citizen/report'),
              icon: const Icon(Icons.add),
              label: const Text('Report Issue'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'My Issues',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Nearby',
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

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

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
                    user?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.black,
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
                        'Hello, ${user?.name.split(' ').first ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Welcome to UrbanSense',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.push('/citizen/notifications'),
                  icon: Badge(
                    label: const Text('2'),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.pending_actions,
                    title: 'Pending',
                    value: '2',
                    color: AppColors.statusInProgress,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_outline,
                    title: 'Resolved',
                    value: '5',
                    color: AppColors.statusResolved,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/citizen/rank-info'),
                    child: _StatCard(
                      icon: Icons.emoji_events,
                      title: 'Rank',
                      value: user?.rank?.toString() ?? '0',
                      color: AppColors.severityMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.report_problem_outlined,
                    label: 'Report Issue',
                    color: AppColors.severityCritical,
                    onTap: () => context.push('/citizen/report'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.track_changes,
                    label: 'Track Status',
                    color: AppColors.statusInProgress,
                    onTap: () {
                      // Navigate to the My Issues tab (index 1)
                      final homeState = context.findAncestorStateOfType<_CitizenHomeScreenState>();
                      homeState?._setTab(1);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.history,
                    label: 'History',
                    color: AppColors.secondary,
                    onTap: () => context.push('/citizen/history'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent complaints
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Issues',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Consumer<ComplaintProvider>(
              builder: (context, provider, child) {
                final complaints = provider.getCitizenComplaints().take(3).toList();
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
                            'No issues reported yet',
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
                  children: complaints
                      .map((c) => ComplaintCard(
                            complaint: c,
                            onTap: () => context.push('/citizen/tracking/${c.id}'),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MyComplaintsTab extends StatelessWidget {
  const _MyComplaintsTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'My Complaints',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Consumer<ComplaintProvider>(
              builder: (context, provider, child) {
                final complaints = provider.getCitizenComplaints();
                if (complaints.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No complaints yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Report an issue to get started',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textHint,
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return ComplaintCard(
                      complaint: complaint,
                      onTap: () => context.push('/citizen/tracking/${complaint.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyTab extends StatefulWidget {
  const _NearbyTab();

  @override
  State<_NearbyTab> createState() => _NearbyTabState();
}

class _NearbyTabState extends State<_NearbyTab> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  String _selectedFilter = 'All';
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    final isExpanded = _sheetController.size > 0.6;
    if (isExpanded != _isExpanded) {
      setState(() => _isExpanded = isExpanded);
    }
  }

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

  List<ComplaintModel> _filterComplaints(List<ComplaintModel> complaints) {
    if (_selectedFilter == 'All') return complaints;
    return complaints.where((c) {
      return c.severity.displayName == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map (full background)
        Positioned.fill(
          child: Consumer<ComplaintProvider>(
            builder: (context, provider, child) {
              return NearbyMapWidget(
                complaints: provider.complaints,
                onMarkerTapped: (complaint) {
                  context.push('/citizen/tracking/${complaint.id}');
                },
              );
            },
          ),
        ),

        // Top header overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.background.withOpacity(0.9),
                  AppColors.background.withOpacity(0),
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nearby Issues',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Tap markers or drag up to see list',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                // Legend button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.surfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.severityLow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.severityMedium,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.severityHigh,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.severityCritical,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Draggable bottom sheet
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.35,
          minChildSize: 0.15,
          maxChildSize: 0.9,
          snap: true,
          snapSizes: const [0.15, 0.35, 0.9],
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(
                    color: AppColors.surfaceVariant,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  GestureDetector(
                    onTap: () {
                      if (_sheetController.size < 0.5) {
                        _sheetController.animateTo(
                          0.9,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      } else {
                        _sheetController.animateTo(
                          0.35,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Consumer<ComplaintProvider>(
                            builder: (context, provider, child) {
                              final count = _filterComplaints(provider.complaints).length;
                              return Text(
                                '$count Issues Nearby',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Filter chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['All', 'Critical', 'High', 'Medium', 'Low'].map((filter) {
                          final isSelected = _selectedFilter == filter;
                          final color = filter == 'All'
                              ? AppColors.primary
                              : filter == 'Critical'
                                  ? AppColors.severityCritical
                                  : filter == 'High'
                                      ? AppColors.severityHigh
                                      : filter == 'Medium'
                                          ? AppColors.severityMedium
                                          : AppColors.severityLow;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() => _selectedFilter = filter);
                              },
                              backgroundColor: AppColors.surfaceVariant,
                              selectedColor: color.withOpacity(0.15),
                              checkmarkColor: color,
                              labelStyle: TextStyle(
                                color: isSelected ? color : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 13,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Issues list
                  Expanded(
                    child: Consumer<ComplaintProvider>(
                      builder: (context, provider, child) {
                        final complaints = _filterComplaints(provider.complaints);
                        
                        if (complaints.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off_outlined,
                                  size: 48,
                                  color: AppColors.textHint,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No issues found',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: complaints.length,
                          itemBuilder: (context, index) {
                            final complaint = complaints[index];
                            final distance = (0.2 + (index * 0.15)).toStringAsFixed(1);
                            
                            return _NearbyIssueCard(
                              complaint: complaint,
                              distance: '$distance km',
                              severityColor: _getSeverityColor(complaint.severity),
                              onTap: () => context.push('/citizen/tracking/${complaint.id}'),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NearbyIssueCard extends StatelessWidget {
  final ComplaintModel complaint;
  final String distance;
  final Color severityColor;
  final VoidCallback onTap;

  const _NearbyIssueCard({
    required this.complaint,
    required this.distance,
    required this.severityColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.surfaceVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Severity indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color: severityColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: severityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            complaint.severity.displayName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: severityColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          complaint.issueType,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      complaint.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      complaint.location,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Distance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.near_me,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

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
                user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'User',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              user?.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),
            // Menu items
            _ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () => context.push('/citizen/edit-profile'),
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => context.push('/citizen/notifications'),
            ),
            _ProfileMenuItem(
              icon: Icons.history,
              title: 'Complaint History',
              onTap: () => context.push('/citizen/history'),
            ),
            _ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => context.push('/citizen/settings'),
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () => context.push('/citizen/help'),
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () => context.push('/citizen/about'),
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

// Helper widgets
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
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
