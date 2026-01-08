import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';

/// Officer help and support screen
class OfficerHelpScreen extends StatelessWidget {
  const OfficerHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      size: 48,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Officer Support',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '24/7 Support for Municipal Officers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.phone,
                    title: 'Call IT Support',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    color: AppColors.secondary,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // FAQ section
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _FAQItem(
              question: 'How do I update issue status?',
              answer: 'Open the issue details, scroll down to the status section, select the new status from the dropdown, and tap "Update Status".',
            ),
            _FAQItem(
              question: 'How to upload resolution proof?',
              answer: 'In the issue details screen, tap the camera icon to capture a photo or gallery to select an existing image as proof of resolution.',
            ),
            _FAQItem(
              question: 'What happens when I reject an issue?',
              answer: 'Rejected issues are returned to the pool and may be reassigned to another officer. Please provide a reason for rejection.',
            ),
            _FAQItem(
              question: 'How is my performance score calculated?',
              answer: 'Performance score is based on: resolution time (40%), citizen ratings (30%), issue priority handling (20%), and completion rate (10%).',
            ),
            _FAQItem(
              question: 'Can I request a zone change?',
              answer: 'Zone change requests can be submitted through Settings > Request Zone Change. Approval typically takes 2-3 working days.',
            ),
            const SizedBox(height: 24),

            // Contact section
            Text(
              'Contact Supervisor',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: const Text('Rajesh Kumar'),
                subtitle: const Text('Zone Supervisor'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.phone_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_outlined),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Resources
            Text(
              'Resources',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _ResourceItem(
              icon: Icons.menu_book,
              title: 'Officer Handbook',
              subtitle: 'Complete guide to using the app',
              onTap: () {},
            ),
            _ResourceItem(
              icon: Icons.video_library,
              title: 'Video Tutorials',
              subtitle: 'Step-by-step training videos',
              onTap: () {},
            ),
            _ResourceItem(
              icon: Icons.policy,
              title: 'Standard Operating Procedures',
              subtitle: 'SOP guidelines for officers',
              onTap: () {},
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.question,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResourceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ResourceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.secondary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
