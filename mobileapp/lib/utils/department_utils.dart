/// Utility class for department-related operations
class DepartmentUtils {
  /// Maps issue types to their corresponding departments
  static String getDepartmentForIssueType(String issueType) {
    switch (issueType) {
      case 'Road Damage':
        return 'Public Works';
      case 'Street Light':
        return 'Electrical';
      case 'Water Leakage':
        return 'Water Supply';
      case 'Garbage':
        return 'Sanitation';
      case 'Sewage':
        return 'Water Supply';
      case 'Noise Pollution':
        return 'Environment';
      case 'Air Pollution':
        return 'Environment';
      case 'Illegal Construction':
        return 'Building';
      case 'Traffic Signal':
        return 'Traffic';
      case 'Public Safety':
        return 'Traffic';
      default:
        return 'General Services';
    }
  }

  /// Get icon for department
  static String getDepartmentIcon(String department) {
    switch (department) {
      case 'Public Works':
        return '🏗️';
      case 'Electrical':
        return '⚡';
      case 'Water Supply':
        return '💧';
      case 'Sanitation':
        return '🗑️';
      case 'Environment':
        return '🌳';
      case 'Building':
        return '🏛️';
      case 'Traffic':
        return '🚦';
      case 'Health':
        return '🏥';
      default:
        return '🏢';
    }
  }
}

/// Rank tier definitions for citizens
class RankTiers {
  static const int bronzeThreshold = 0;
  static const int silverThreshold = 500;
  static const int goldThreshold = 1000;
  static const int platinumThreshold = 2000;
  static const int diamondThreshold = 5000;

  static String getTierName(int rank) {
    if (rank >= diamondThreshold) return 'Diamond';
    if (rank >= platinumThreshold) return 'Platinum';
    if (rank >= goldThreshold) return 'Gold';
    if (rank >= silverThreshold) return 'Silver';
    return 'Bronze';
  }

  static String getTierEmoji(int rank) {
    if (rank >= diamondThreshold) return '💎';
    if (rank >= platinumThreshold) return '🏆';
    if (rank >= goldThreshold) return '🥇';
    if (rank >= silverThreshold) return '🥈';
    return '🥉';
  }
}
