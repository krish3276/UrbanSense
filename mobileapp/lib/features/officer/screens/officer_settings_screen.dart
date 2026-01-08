import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';

/// Officer settings screen
class OfficerSettingsScreen extends StatefulWidget {
  const OfficerSettingsScreen({super.key});

  @override
  State<OfficerSettingsScreen> createState() => _OfficerSettingsScreenState();
}

class _OfficerSettingsScreenState extends State<OfficerSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _criticalAlerts = true;
  bool _locationTracking = true;
  bool _autoAccept = false;
  String _mapStyle = 'Standard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          // Notifications section
          _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications_outlined, color: AppColors.secondary),
            ),
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive new assignment alerts'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.severityCritical.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber_outlined, color: AppColors.severityCritical),
            ),
            title: const Text('Critical Alerts'),
            subtitle: const Text('Priority alerts for critical issues'),
            value: _criticalAlerts,
            onChanged: (value) => setState(() => _criticalAlerts = value),
          ),
          const Divider(height: 1),

          // Work preferences section
          _SectionHeader(title: 'Work Preferences'),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.location_on_outlined, color: AppColors.primary),
            ),
            title: const Text('Location Tracking'),
            subtitle: const Text('Share location while on duty'),
            value: _locationTracking,
            onChanged: (value) => setState(() => _locationTracking = value),
          ),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.severityLow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.severityLow),
            ),
            title: const Text('Auto-Accept Assignments'),
            subtitle: const Text('Automatically accept new issues'),
            value: _autoAccept,
            onChanged: (value) => setState(() => _autoAccept = value),
          ),
          const Divider(height: 1),

          // Map settings
          _SectionHeader(title: 'Map Settings'),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.severityMedium.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.map_outlined, color: AppColors.severityMedium),
            ),
            title: const Text('Map Style'),
            subtitle: Text(_mapStyle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.map),
                      title: const Text('Standard'),
                      trailing: _mapStyle == 'Standard' 
                          ? const Icon(Icons.check, color: AppColors.secondary) 
                          : null,
                      onTap: () {
                        setState(() => _mapStyle = 'Standard');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.satellite),
                      title: const Text('Satellite'),
                      trailing: _mapStyle == 'Satellite' 
                          ? const Icon(Icons.check, color: AppColors.secondary) 
                          : null,
                      onTap: () {
                        setState(() => _mapStyle = 'Satellite');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.terrain),
                      title: const Text('Terrain'),
                      trailing: _mapStyle == 'Terrain' 
                          ? const Icon(Icons.check, color: AppColors.secondary) 
                          : null,
                      onTap: () {
                        setState(() => _mapStyle = 'Terrain');
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),

          // Account section
          _SectionHeader(title: 'Account'),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.badge_outlined, color: AppColors.secondary),
            ),
            title: const Text('Officer ID'),
            subtitle: const Text('OFF-2024-001234'),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.business_outlined, color: AppColors.primary),
            ),
            title: const Text('Department'),
            subtitle: const Text('Roads & Infrastructure'),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.severityLow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: AppColors.severityLow),
            ),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0 (Build 1)'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
