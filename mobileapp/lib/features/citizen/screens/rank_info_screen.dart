import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../utils/department_utils.dart';

/// Screen explaining the citizen rank system
class RankInfoScreen extends StatelessWidget {
  const RankInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final currentRank = user?.rank ?? 0;
    final tierName = RankTiers.getTierName(currentRank);
    final tierEmoji = RankTiers.getTierEmoji(currentRank);
    
    // Calculate progress to next tier
    final nextTierThreshold = _getNextTierThreshold(currentRank);
    final prevTierThreshold = _getPrevTierThreshold(currentRank);
    final progressToNext = nextTierThreshold > 0
        ? ((currentRank - prevTierThreshold) / (nextTierThreshold - prevTierThreshold)).clamp(0.0, 1.0)
        : 1.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Rank'),
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
            // Enhanced rank display card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Emoji with glow effect
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      tierEmoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Current Rank',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentRank.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '$tierName Tier',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Progress to next tier
                  if (nextTierThreshold > 0) ...[
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress to ${_getNextTierName(currentRank)}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${currentRank}/${nextTierThreshold}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progressToNext,
                            minHeight: 8,
                            backgroundColor: Colors.black.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation(Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${nextTierThreshold - currentRank} points to go!',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // What is Rank?
            _SectionHeader(title: 'What is Rank?'),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: AppColors.surfaceVariant,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.2),
                                AppColors.primary.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Your rank is your contribution score as an active citizen!',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rank is different from feedback rating. It represents your overall contribution to the community.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // How to earn rank points
            _SectionHeader(title: 'How to Earn Points'),
            const SizedBox(height: 12),
            _PointsCard(
              icon: Icons.report_problem,
              title: 'Report Issues',
              description: 'Earn points for each issue you report',
              points: '+50',
              color: AppColors.primary,
            ),
            _PointsCard(
              icon: Icons.check_circle,
              title: 'Issue Resolution',
              description: 'Bonus when your issue is resolved',
              points: '+100',
              color: AppColors.success,
            ),
            _PointsCard(
              icon: Icons.star,
              title: 'Quality Reports',
              description: 'Extra points for detailed reports with photos',
              points: '+25',
              color: AppColors.warning,
            ),
            _PointsCard(
              icon: Icons.feedback,
              title: 'Provide Feedback',
              description: 'Rate resolved complaints to earn',
              points: '+20',
              color: AppColors.info,
            ),
            const SizedBox(height: 32),

            // Rank tiers
            _SectionHeader(title: 'Rank Tiers'),
            const SizedBox(height: 12),
            _TierCard(
              emoji: '🥉',
              title: 'Bronze',
              range: '0-499 points',
              color: const Color(0xFFCD7F32),
              isCurrentTier: currentRank < RankTiers.silverThreshold,
            ),
            _TierCard(
              emoji: '🥈',
              title: 'Silver',
              range: '500-999 points',
              color: const Color(0xFFC0C0C0),
              isCurrentTier: currentRank >= RankTiers.silverThreshold &&
                  currentRank < RankTiers.goldThreshold,
            ),
            _TierCard(
              emoji: '🥇',
              title: 'Gold',
              range: '1000-1999 points',
              color: AppColors.primary,
              isCurrentTier: currentRank >= RankTiers.goldThreshold &&
                  currentRank < RankTiers.platinumThreshold,
            ),
            _TierCard(
              emoji: '🏆',
              title: 'Platinum',
              range: '2000-4999 points',
              color: const Color(0xFF229954),
              isCurrentTier: currentRank >= RankTiers.platinumThreshold &&
                  currentRank < RankTiers.diamondThreshold,
            ),
            _TierCard(
              emoji: '💎',
              title: 'Diamond',
              range: '5000+ points',
              color: const Color(0xFF667eea),
              isCurrentTier: currentRank >= RankTiers.diamondThreshold,
            ),
            const SizedBox(height: 32),

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.pop();
                  context.push('/citizen/report');
                },
                icon: const Icon(Icons.add_circle_outline, size: 22),
                label: const Text('Report an Issue Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  int _getNextTierThreshold(int currentRank) {
    if (currentRank < RankTiers.silverThreshold) return RankTiers.silverThreshold;
    if (currentRank < RankTiers.goldThreshold) return RankTiers.goldThreshold;
    if (currentRank < RankTiers.platinumThreshold) return RankTiers.platinumThreshold;
    if (currentRank < RankTiers.diamondThreshold) return RankTiers.diamondThreshold;
    return 0; // Already at max tier
  }

  int _getPrevTierThreshold(int currentRank) {
    if (currentRank < RankTiers.silverThreshold) return 0;
    if (currentRank < RankTiers.goldThreshold) return RankTiers.silverThreshold;
    if (currentRank < RankTiers.platinumThreshold) return RankTiers.goldThreshold;
    if (currentRank < RankTiers.diamondThreshold) return RankTiers.platinumThreshold;
    return RankTiers.diamondThreshold;
  }

  String _getNextTierName(int currentRank) {
    if (currentRank < RankTiers.silverThreshold) return 'Silver';
    if (currentRank < RankTiers.goldThreshold) return 'Gold';
    if (currentRank < RankTiers.platinumThreshold) return 'Platinum';
    if (currentRank < RankTiers.diamondThreshold) return 'Diamond';
    return 'Max';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}

class _PointsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String points;
  final Color color;

  const _PointsCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.points,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.surfaceVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                points,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String range;
  final Color color;
  final bool isCurrentTier;

  const _TierCard({
    required this.emoji,
    required this.title,
    required this.range,
    required this.color,
    required this.isCurrentTier,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isCurrentTier ? 4 : 0,
      color: isCurrentTier ? color.withOpacity(0.12) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCurrentTier ? color : AppColors.surfaceVariant,
          width: isCurrentTier ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: isCurrentTier
                    ? LinearGradient(
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.15),
                        ],
                      )
                    : null,
                color: isCurrentTier ? null : AppColors.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: isCurrentTier ? 32 : 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCurrentTier ? color : AppColors.textPrimary,
                            ),
                      ),
                      if (isCurrentTier) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'CURRENT',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    range,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isCurrentTier
                              ? color.withOpacity(0.8)
                              : AppColors.textSecondary,
                          fontWeight:
                              isCurrentTier ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
