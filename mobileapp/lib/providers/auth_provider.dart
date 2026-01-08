import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/dummy_data.dart';

/// Auth provider for managing login state and role
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserRole? _selectedRole;
  UserModel? _currentUser;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  UserRole? get selectedRole => _selectedRole;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadSavedRole();
  }

  /// Load saved role from shared preferences
  Future<void> _loadSavedRole() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMobile = prefs.getString('user_mobile');
      final savedRole = prefs.getString('user_role');
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (isLoggedIn && savedMobile != null && savedRole != null) {
        _isLoggedIn = true;
        // Recreate user from mobile number
        if (savedRole == 'officer' && DummyData.officerNumbers.containsKey(savedMobile)) {
          final officerData = DummyData.officerNumbers[savedMobile]!;
          _selectedRole = UserRole.officer;
          _currentUser = UserModel(
            id: officerData['id']!,
            name: officerData['name']!,
            phone: savedMobile,
            email: '${officerData['name']!.toLowerCase().replaceAll(' ', '.')}@urbansense.gov',
            role: UserRole.officer,
            createdAt: DateTime.now().subtract(const Duration(days: 120)),
            department: officerData['department'],
          );
        } else {
          _selectedRole = UserRole.citizen;
          _currentUser = UserModel(
            id: 'citizen_${savedMobile.substring(savedMobile.length - 4)}',
            name: 'Citizen User',
            phone: savedMobile,
            email: 'user@email.com',
            role: UserRole.citizen,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            rank: 1000,
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading saved role: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Login with mobile number (auto role detection)
  Future<void> loginWithMobile(String mobile) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Normalize mobile number (remove spaces, +91, etc.)
    final normalizedMobile = mobile.replaceAll(RegExp(r'[^0-9]'), '');
    final last10Digits = normalizedMobile.length >= 10
        ? normalizedMobile.substring(normalizedMobile.length - 10)
        : normalizedMobile;

    // Check if mobile exists in officer list
    if (DummyData.officerNumbers.containsKey(last10Digits)) {
      final officerData = DummyData.officerNumbers[last10Digits]!;
      _selectedRole = UserRole.officer;
      _currentUser = UserModel(
        id: officerData['id']!,
        name: officerData['name']!,
        phone: last10Digits,
        email: '${officerData['name']!.toLowerCase().replaceAll(' ', '.')}@urbansense.gov',
        role: UserRole.officer,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        department: officerData['department'],
      );
    } else {
      // Default to citizen
      _selectedRole = UserRole.citizen;
      _currentUser = UserModel(
        id: 'citizen_${last10Digits.substring(last10Digits.length - 4)}',
        name: 'Citizen User',
        phone: last10Digits,
        email: 'user@email.com',
        role: UserRole.citizen,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        rank: 1000,
      );
    }

    _isLoggedIn = true;

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_mobile', last10Digits);
    await prefs.setString('user_role', _selectedRole == UserRole.citizen ? 'citizen' : 'officer');
    await prefs.setBool('is_logged_in', true);

    _isLoading = false;
    notifyListeners();
  }

  /// Login with phone/email (mock) - DEPRECATED, use loginWithMobile instead
  Future<bool> login(String identifier) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Set user role
  Future<void> setRole(UserRole role) async {
    _selectedRole = role;
    _currentUser = role == UserRole.citizen
        ? DummyData.currentCitizen
        : DummyData.currentOfficer;

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role == UserRole.citizen ? 'citizen' : 'officer');
    await prefs.setBool('is_logged_in', true);

    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.setBool('is_logged_in', false);

    _isLoggedIn = false;
    _selectedRole = null;
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Check if user has selected a role
  bool get hasSelectedRole => _selectedRole != null;

  /// Check if user is a citizen
  bool get isCitizen => _selectedRole == UserRole.citizen;

  /// Check if user is an officer
  bool get isOfficer => _selectedRole == UserRole.officer;
}
