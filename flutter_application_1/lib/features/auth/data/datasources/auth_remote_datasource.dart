import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

class AuthRemoteDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ========== AUTH OPERATIONS ==========

  /// Register new user
  Future<UserProfileModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // 1. Create auth user
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create user account');
      }

      final userId = authResponse.user!.id;

      // 2. Create profile in database
      final now = DateTime.now().toUtc();
      final profileData = {
        'id': userId,
        'email': email,
        'username': username,
        'avatar_url': ApiConstants.defaultAvatarImage,
        'bio': '',
        'role': ApiConstants.roleUser,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final profileResponse = await _supabase
          .from(ApiConstants.profilesTable)
          .insert(profileData)
          .select()
          .single();

      return UserProfileModel.fromJson(profileResponse);
    } on AuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    } on PostgrestException catch (e) {
      throw Exception('Profile creation failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during registration: $e');
    }
  }

  /// Login user
  Future<UserProfileModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Sign in with Supabase Auth
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Login failed');
      }

      final userId = authResponse.user!.id;

      // 2. Fetch user profile
      final profileResponse = await _supabase
          .from(ApiConstants.profilesTable)
          .select()
          .eq('id', userId)
          .single();

      final profile = UserProfileModel.fromJson(profileResponse);

      // 3. Check if user is banned
      if (profile.isBanned) {
        await logout();
        throw Exception('Your account has been banned');
      }

      return profile;
    } on AuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch profile: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during login: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Get current user profile
  Future<UserProfileModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final profileResponse = await _supabase
          .from(ApiConstants.profilesTable)
          .select()
          .eq('id', user.id)
          .single();

      return UserProfileModel.fromJson(profileResponse);
    } catch (e) {
      return null;
    }
  }

  /// Check if username exists
  Future<bool> isUsernameExists(String username) async {
    try {
      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .select('username')
          .eq('username', username)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // ========== PROFILE OPERATIONS ==========

  /// Update user profile
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      if (updates.isEmpty) {
        throw Exception('No fields to update');
      }

      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Profile update failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during profile update: $e');
    }
  }

  /// Get user profile by ID
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .select()
          .eq('id', userId)
          .single();

      return UserProfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch user profile: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ========== ADMIN OPERATIONS ==========

  /// Get all users (Admin only)
  Future<List<UserProfileModel>> getAllUsers() async {
    try {
      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => UserProfileModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch users: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Ban/Unban user (Admin only)
  Future<UserProfileModel> updateUserRole({
    required String userId,
    required String role,
  }) async {
    try {
      if (!['user', 'admin', 'banned'].contains(role)) {
        throw Exception('Invalid role');
      }

      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .update({'role': role})
          .eq('id', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update user role: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Search users by username or email
  Future<List<UserProfileModel>> searchUsers(String query) async {
    try {
      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .select()
          .or('username.ilike.%$query%,email.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => UserProfileModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Search failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}