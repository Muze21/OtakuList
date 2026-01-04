// lib/data/data_sources/remote/auth_remote_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../core/errors/exceptions.dart';
import '../../models/profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<ProfileModel> login({required String email, required String password});
  Future<ProfileModel> register({
    required String email,
    required String password,
    required String username,
  });
  Future<void> logout();
  Future<ProfileModel?> getCurrentUser();
  Future<ProfileModel> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  });
  Stream<ProfileModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<ProfileModel> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Attempting login with email: $email');
      
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Login failed');
      }

      print('✅ Login successful, user ID: ${response.user!.id}');

      // Get profile from database
      final profileData = await client
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle(); // ⚠️ DIUBAH dari .single() ke .maybeSingle()

      if (profileData == null) {
        throw AuthException('Profile not found');
      }

      print('✅ Profile retrieved');
      return ProfileModel.fromJson(profileData);
    } catch (e) {
      print('❌ Login error: $e');
      if (e is AuthException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProfileModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      print('📝 Attempting signup with email: $email, username: $username');
      
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      print('📝 Signup response: user=${response.user?.id}, session=${response.session != null}');

      if (response.user == null) {
        throw AuthException('Registration failed - no user returned');
      }

      print('✅ User created, ID: ${response.user!.id}');
      print('📝 Creating profile in database...');

      // Create profile
      final profileData = await client
          .from('profiles')
          .insert({
            'id': response.user!.id,
            'email': email,
            'username': username,
            'role': 'user',
          })
          .select()
          .maybeSingle(); // ⚠️ DIUBAH untuk konsistensi

      if (profileData == null) {
        throw ServerException('Failed to create profile');
      }

      print('✅ Profile created successfully: $profileData');
      return ProfileModel.fromJson(profileData);
    } catch (e) {
      print('❌ Registration error: $e');
      print('❌ Error type: ${e.runtimeType}');
      if (e.toString().contains('already registered') || 
          e.toString().contains('already exists')) {
        throw AuthException('Email already registered');
      }
      if (e is AuthException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      print('🚪 Logging out...');
      await client.auth.signOut();
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProfileModel?> getCurrentUser() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        print('ℹ️ No current user');
        return null;
      }

      print('ℹ️ Getting profile for user: ${user.id}');

      final profileData = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle(); // ⚠️ DIUBAH dari .single() ke .maybeSingle()

      if (profileData == null) {
        print('⚠️ Profile not found for user: ${user.id}');
        return null;
      }

      return ProfileModel.fromJson(profileData);
    } catch (e) {
      print('❌ Get current user error: $e');
      return null;
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        throw AuthException('Not authenticated');
      }

      print('🔄 Updating profile for user: ${user.id}');

      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final profileData = await client
          .from('profiles')
          .update(updates)
          .eq('id', user.id)
          .select()
          .maybeSingle(); // ⚠️ DIUBAH untuk konsistensi

      if (profileData == null) {
        throw ServerException('Failed to update profile');
      }

      print('✅ Profile updated successfully');
      return ProfileModel.fromJson(profileData);
    } catch (e) {
      print('❌ Update profile error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<ProfileModel?> get authStateChanges {
    return client.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;
      if (user == null) {
        print('🔔 Auth state changed: logged out');
        return null;
      }

      try {
        print('🔔 Auth state changed: user ${user.id}');
        final profileData = await client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle(); // ⚠️ DIUBAH untuk konsistensi
        
        if (profileData == null) {
          print('⚠️ Profile not found for user: ${user.id}');
          return null;
        }
        
        return ProfileModel.fromJson(profileData);
      } catch (e) {
        print('❌ Auth state change error: $e');
        return null;
      }
    });
  }
}