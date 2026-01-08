import 'package:flutter/material.dart';

/// App-wide color constants - Dark Theme with Gold Accents
class AppColors {
  // Background colors
  static const Color background = Color(0xFF0B0B0B);           // #0B0B0B - App Background
  static const Color surface = Color(0xFF151515);              // #151515 - Card / Surface Background
  static const Color surfaceSecondary = Color(0xFF1E1E1E);     // #1E1E1E - Secondary Surface / Bottom Nav
  static const Color surfaceVariant = Color(0xFF2A2A2A);       // #2A2A2A - Dividers / Disabled State
  
  // Primary colors - Gold Accents
  static const Color primary = Color(0xFFD4A73C);              // #D4A73C - Primary Accent / CTA / Active Icons
  static const Color primaryDark = Color(0xFFB8963B);          // #B8963B - Secondary Accent / Highlights
  static const Color primaryLight = Color(0xFFE5BC5A);         // Lighter gold for hover states
  
  // Secondary colors (keeping gold theme)
  static const Color secondary = Color(0xFFB8963B);            // #B8963B - Secondary Accent
  static const Color secondaryDark = Color(0xFFA08230);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);          // #FFFFFF - Primary Text / Headings
  static const Color textSecondary = Color(0xFFD6D6D6);        // #D6D6D6 - Body Text
  static const Color textHint = Color(0xFF9A9A9A);             // #9A9A9A - Hint / Muted Text
  
  // Severity colors
  static const Color severityCritical = Color(0xFFE74C3C);     // #E74C3C - Critical / High Priority Issues
  static const Color severityHigh = Color(0xFFF39C12);         // #F39C12 - Warning / Medium Priority
  static const Color severityMedium = Color(0xFFF39C12);       // #F39C12 - Warning / Medium Priority
  static const Color severityLow = Color(0xFF2ECC71);          // #2ECC71 - Success / Resolved
  
  // Status colors
  static const Color statusSubmitted = Color(0xFF9A9A9A);      // Muted text color
  static const Color statusInProgress = Color(0xFF3498DB);     // #3498DB - Info / AI Processing
  static const Color statusResolved = Color(0xFF2ECC71);       // #2ECC71 - Success / Resolved
  static const Color statusClosed = Color(0xFF9A9A9A);
  
  // Additional semantic colors
  static const Color success = Color(0xFF2ECC71);              // #2ECC71 - Success / Resolved
  static const Color warning = Color(0xFFF39C12);              // #F39C12 - Warning / Medium Priority
  static const Color error = Color(0xFFE74C3C);                // #E74C3C - Critical / High Priority
  static const Color info = Color(0xFF3498DB);                 // #3498DB - Info / AI Processing
  
  // Gradients with new gold theme
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4A73C), Color(0xFFB8963B)],
  );
  
  static const LinearGradient citizenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE5BC5A), Color(0xFFD4A73C)],
  );
  
  static const LinearGradient officerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4A73C), Color(0xFFA08230)],
  );
}

/// Issue type constants
class IssueTypes {
  static const List<String> all = [
    'Road Damage',
    'Street Light',
    'Garbage',
    'Water Leakage',
    'Sewage',
    'Noise Pollution',
    'Air Pollution',
    'Illegal Construction',
    'Traffic Signal',
    'Public Safety',
    'Other',
  ];
}

/// Department constants
class Departments {
  static const List<String> all = [
    'Public Works',
    'Sanitation',
    'Water Supply',
    'Electrical',
    'Traffic',
    'Environment',
    'Building',
    'Health',
  ];
}
