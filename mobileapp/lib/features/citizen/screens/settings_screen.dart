import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkMode = false;
  String _language = 'English';

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
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            ),
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive updates about your issues'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          const Divider(height: 1),

          // Privacy section
          _SectionHeader(title: 'Privacy'),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.location_on_outlined, color: AppColors.secondary),
            ),
            title: const Text('Location Services'),
            subtitle: const Text('Allow access to your location'),
            value: _locationEnabled,
            onChanged: (value) => setState(() => _locationEnabled = value),
          ),
          const Divider(height: 1),

          // Appearance section
          _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _darkMode ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.textPrimary,
              ),
            ),
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dark mode coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.severityMedium.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.language, color: AppColors.severityMedium),
            ),
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('English'),
                      leading: const Text('🇺🇸'),
                      trailing: _language == 'English' 
                          ? const Icon(Icons.check, color: AppColors.primary) 
                          : null,
                      onTap: () {
                        setState(() => _language = 'English');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Hindi'),
                      leading: const Text('🇮🇳'),
                      trailing: _language == 'Hindi' 
                          ? const Icon(Icons.check, color: AppColors.primary) 
                          : null,
                      onTap: () {
                        setState(() => _language = 'Hindi');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Gujarati'),
                      leading: const Text('🇮🇳'),
                      trailing: _language == 'Gujarati' 
                          ? const Icon(Icons.check, color: AppColors.primary) 
                          : null,
                      onTap: () {
                        setState(() => _language = 'Gujarati');
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

          // About section
          _SectionHeader(title: 'About'),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: AppColors.primary),
            ),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0 (Build 1)'),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description_outlined, color: AppColors.secondary),
            ),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Terms of Service'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'URBANSENSE TERMS OF SERVICE\n\n'
                      '1. Acceptance of Terms\n'
                      'By accessing and using UrbanSense, you accept and agree to be bound by these terms.\n\n'
                      '2. User Responsibilities\n'
                      '- Provide accurate information\n'
                      '- Report genuine civic issues\n'
                      '- Respect other users\n\n'
                      '3. Privacy\n'
                      'We protect your personal information as described in our Privacy Policy.\n\n'
                      '4. Content\n'
                      'Users retain rights to their submitted content but grant us license to use it for service improvement.\n\n'
                      '5. Service Availability\n'
                      'We strive for 24/7 availability but do not guarantee uninterrupted service.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.severityLow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.privacy_tip_outlined, color: AppColors.severityLow),
            ),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Privacy Policy'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'URBANSENSE PRIVACY POLICY\n\n'
                      '1. Information We Collect\n'
                      '- Name, phone number, email\n'
                      '- Location data (with permission)\n'
                      '- Issue reports and feedback\n\n'
                      '2. How We Use Information\n'
                      '- Process civic issue reports\n'
                      '- Improve city services\n'
                      '- Send notifications\n'
                      '- Generate analytics\n\n'
                      '3. Data Sharing\n'
                      'We share data only with relevant municipal departments for issue resolution.\n\n'
                      '4. Data Security\n'
                      'We implement industry-standard security measures to protect your data.\n\n'
                      '5. Your Rights\n'
                      'You can access, modify, or delete your personal data at any time.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
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
