import 'package:flutter_application_1/features/admin/data/datasources/admin_datasource.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

class AdminRepository {
  final AdminDatasource _datasource;

  AdminRepository(this._datasource);

  /// Get all users
  Future<List<UserProfileModel>> getAllUsers() async {
    return await _datasource.getAllUsers();
  }

  /// Toggle user ban status
  Future<void> toggleBanUser(String userId, bool isBanned) async {
    return await _datasource.toggleBanUser(userId, isBanned);
  }

  /// Get user by ID
  Future<UserProfileModel> getUserById(String userId) async {
    return await _datasource.getUserById(userId);
  }
}
