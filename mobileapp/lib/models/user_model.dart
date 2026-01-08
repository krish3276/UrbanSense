/// User roles in the app
enum UserRole { citizen, officer }

/// User model
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;
  
  // Citizen-specific fields
  final int? rank; // Contribution score for citizens
  
  // Officer-specific fields
  final String? department; // Department assignment for officers

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    this.rank,
    this.department,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    String? avatarUrl,
    DateTime? createdAt,
    int? rank,
    String? department,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      rank: rank ?? this.rank,
      department: department ?? this.department,
    );
  }
}
