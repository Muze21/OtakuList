import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Register new user
  Future<UserProfileModel> register({
    required String email,
    required String password,
    required String username,
  });

  /// Login user
  Future<UserProfileModel> login({
    required String email,
    required String password,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current logged in user
  Future<UserProfileModel?> getCurrentUser();

  /// Update user profile
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? username,
    String? bio,
    String? avatarUrl,
  });

  /// Check if username already exists
  Future<bool> isUsernameExists(String username);

  /// Get user profile by ID
  Future<UserProfileModel> getUserProfile(String userId);

  // Admin operations
  Future<List<UserProfileModel>> getAllUsers();
  Future<UserProfileModel> updateUserRole({
    required String userId,
    required String role,
  });
  Future<List<UserProfileModel>> searchUsers(String query);
}