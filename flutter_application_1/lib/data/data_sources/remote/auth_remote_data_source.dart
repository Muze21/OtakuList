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
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Login failed');
      }

      // Get profile from database
      final profileData = await client
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return ProfileModel.fromJson(profileData);
    } catch (e) {
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
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Registration failed');
      }

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
          .single();

      return ProfileModel.fromJson(profileData);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProfileModel?> getCurrentUser() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        return null;
      }

      final profileData = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return ProfileModel.fromJson(profileData);
    } catch (e) {
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
          .single();

      return ProfileModel.fromJson(profileData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<ProfileModel?> get authStateChanges {
    return client.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;
      if (user == null) return null;

      try {
        final profileData = await client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
        return ProfileModel.fromJson(profileData);
      } catch (e) {
        return null;
      }
    });
  }
}
