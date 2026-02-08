import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/admin/data/datasources/admin_datasource.dart';
import 'package:flutter_application_1/features/admin/data/repositories/admin_repository.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

/// Admin Datasource Provider
final adminDatasourceProvider = Provider<AdminDatasource>((ref) {
  return AdminDatasource();
});

/// Admin Repository Provider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final datasource = ref.watch(adminDatasourceProvider);
  return AdminRepository(datasource);
});

/// All Users Provider
final allUsersProvider = FutureProvider<List<UserProfileModel>>((ref) async {
  final repository = ref.watch(adminRepositoryProvider);
  return await repository.getAllUsers();
});

/// Get single user by ID
final userByIdProvider = FutureProvider.family<UserProfileModel, String>((ref, userId) async {
  final repository = ref.watch(adminRepositoryProvider);
  return await repository.getUserById(userId);
});
