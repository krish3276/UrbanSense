import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';

/// Help and support screen
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How can we help?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re here to assist you',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Contact options
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _ContactCard(
              icon: Icons.phone_outlined,
              title: 'Call Support',
              subtitle: '+91 79 1234 5678',
              color: AppColors.primary,
              onTap: () {},
            ),
            _ContactCard(
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: 'support@urbansense.gov.in',
              color: AppColors.secondary,
              onTap: () {},
            ),
            _ContactCard(
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Available 9 AM - 6 PM',
              color: AppColors.severityLow,
              onTap: () {},
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
              question: 'How do I report an issue?',
              answer: 'Tap the "Report Issue" button on the home screen, fill in the details, add photos if needed, and submit. Our AI will automatically categorize and prioritize your report.',
            ),
            _FAQItem(
              question: 'How long does it take to resolve an issue?',
              answer: 'Resolution time depends on the severity and type of issue. Critical issues are typically addressed within 24 hours, while regular issues may take 3-7 business days.',
            ),
            _FAQItem(
              question: 'Can I track my complaint status?',
              answer: 'Yes! Go to "My Issues" section to see all your complaints and their current status. You\'ll also receive notifications when there are updates.',
            ),
            _FAQItem(
              question: 'How do I give feedback?',
              answer: 'Once your issue is resolved, you\'ll receive a notification to rate the service. You can also provide feedback anytime from the complaint details page.',
            ),
            const SizedBox(height: 24),

            // Quick links
            Text(
              'Quick Links',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickLinkChip(label: 'User Guide', onTap: () {}),
                _QuickLinkChip(label: 'Video Tutorial', onTap: () {}),
                _QuickLinkChip(label: 'Community Forum', onTap: () {}),
                _QuickLinkChip(label: 'Report Bug', onTap: () {}),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
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

class _QuickLinkChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickLinkChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: const Icon(Icons.link, size: 16),
    );
  }
}
