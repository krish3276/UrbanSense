import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

// Auth screens
import '../features/auth/screens/login_screen.dart';

// Citizen screens
import '../features/citizen/screens/citizen_home_screen.dart';
import '../features/citizen/screens/report_issue_screen.dart';
import '../features/citizen/screens/ai_analysis_screen.dart';
import '../features/citizen/screens/complaint_tracking_screen.dart';
import '../features/citizen/screens/notifications_screen.dart';
import '../features/citizen/screens/feedback_screen.dart';
import '../features/citizen/screens/edit_profile_screen.dart';
import '../features/citizen/screens/settings_screen.dart';
import '../features/citizen/screens/help_support_screen.dart';
import '../features/citizen/screens/complaint_history_screen.dart';
import '../features/citizen/screens/about_screen.dart';
import '../features/citizen/screens/rank_info_screen.dart';

// Officer screens
import '../features/officer/screens/officer_dashboard_screen.dart';
import '../features/officer/screens/issue_details_screen.dart';
import '../features/officer/screens/work_history_screen.dart';
import '../features/officer/screens/analytics_screen.dart';
import '../features/officer/screens/officer_settings_screen.dart';
import '../features/officer/screens/officer_help_screen.dart';
import '../features/officer/screens/officer_notifications_screen.dart';

/// App router configuration
class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final hasRole = authProvider.hasSelectedRole;
      final currentPath = state.matchedLocation;

      // If not logged in, redirect to login
      if (!isLoggedIn && currentPath != '/login') {
        return '/login';
      }

      // If logged in and on login page, redirect to appropriate dashboard
      if (isLoggedIn && currentPath == '/login') {
        return authProvider.isCitizen ? '/citizen' : '/officer';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Citizen routes
      GoRoute(
        path: '/citizen',
        name: 'citizen-home',
        builder: (context, state) => const CitizenHomeScreen(),
        routes: [
          GoRoute(
            path: 'report',
            name: 'report-issue',
            builder: (context, state) => const ReportIssueScreen(),
          ),
          GoRoute(
            path: 'ai-analysis',
            name: 'ai-analysis',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return AiAnalysisScreen(
                title: extra?['title'] ?? '',
                description: extra?['description'] ?? '',
                issueType: extra?['issueType'] ?? '',
                location: extra?['location'] ?? '',
                imagePath: extra?['imagePath'],
              );
            },
          ),
          GoRoute(
            path: 'tracking/:id',
            name: 'complaint-tracking',
            builder: (context, state) {
              final complaintId = state.pathParameters['id']!;
              return ComplaintTrackingScreen(complaintId: complaintId);
            },
          ),
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: 'feedback/:id',
            name: 'feedback',
            builder: (context, state) {
              final complaintId = state.pathParameters['id']!;
              return FeedbackScreen(complaintId: complaintId);
            },
          ),
          GoRoute(
            path: 'edit-profile',
            name: 'edit-profile',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'help',
            name: 'help-support',
            builder: (context, state) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: 'history',
            name: 'complaint-history',
            builder: (context, state) => const ComplaintHistoryScreen(),
          ),
          GoRoute(
            path: 'about',
            name: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: 'rank-info',
            name: 'rank-info',
            builder: (context, state) => const RankInfoScreen(),
          ),
        ],
      ),

      // Officer routes
      GoRoute(
        path: '/officer',
        name: 'officer-dashboard',
        builder: (context, state) => const OfficerDashboardScreen(),
        routes: [
          GoRoute(
            path: 'issue/:id',
            name: 'issue-details',
            builder: (context, state) {
              final complaintId = state.pathParameters['id']!;
              return IssueDetailsScreen(complaintId: complaintId);
            },
          ),
          GoRoute(
            path: 'history',
            name: 'work-history',
            builder: (context, state) => const WorkHistoryScreen(),
          ),
          GoRoute(
            path: 'analytics',
            name: 'officer-analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'officer-settings',
            builder: (context, state) => const OfficerSettingsScreen(),
          ),
          GoRoute(
            path: 'help',
            name: 'officer-help',
            builder: (context, state) => const OfficerHelpScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: 'officer-notifications',
            builder: (context, state) => const OfficerNotificationsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('Path: ${state.matchedLocation}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}
