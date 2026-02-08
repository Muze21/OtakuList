import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

class AdminDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all users
  Future<List<UserProfileModel>> getAllUsers() async {
    try {
      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => UserProfileModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('[ADMIN ERROR] Failed to fetch users: $e');
    }
  }

  /// Ban/Unban user
  Future<void> toggleBanUser(String userId, bool isBanned) async {
    try {
      await _supabase
          .from(ApiConstants.profilesTable)
          .update({'is_banned': isBanned})
          .eq('id', userId);
    } catch (e) {
      throw Exception('[ADMIN ERROR] Failed to update ban status: $e');
    }
  }

  /// Get user by ID
  Future<UserProfileModel> getUserById(String userId) async {
    try {
      final response = await _supabase
          .from(ApiConstants.profilesTable)
          .select()
          .eq('id', userId)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('[ADMIN ERROR] Failed to fetch user: $e');
    }
  }
}
