import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._remoteDatasource);

  @override
  Future<UserProfileModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _remoteDatasource.register(
      email: email,
      password: password,
      username: username,
    );
  }

  @override
  Future<UserProfileModel> login({
    required String email,
    required String password,
  }) async {
    return await _remoteDatasource.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    return await _remoteDatasource.logout();
  }

  @override
  Future<UserProfileModel?> getCurrentUser() async {
    return await _remoteDatasource.getCurrentUser();
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    return await _remoteDatasource.updateProfile(
      userId: userId,
      username: username,
      bio: bio,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<bool> isUsernameExists(String username) async {
    return await _remoteDatasource.isUsernameExists(username);
  }

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    return await _remoteDatasource.getUserProfile(userId);
  }

  @override
  Future<List<UserProfileModel>> getAllUsers() async {
    return await _remoteDatasource.getAllUsers();
  }

  @override
  Future<UserProfileModel> updateUserRole({
    required String userId,
    required String role,
  }) async {
    return await _remoteDatasource.updateUserRole(
      userId: userId,
      role: role,
    );
  }

  @override
  Future<List<UserProfileModel>> searchUsers(String query) async {
    return await _remoteDatasource.searchUsers(query);
  }
}