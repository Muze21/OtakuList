import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_text_styles.dart';
import 'package:flutter_application_1/core/utils/responsive_helper.dart';
import 'package:flutter_application_1/features/admin/presentation/providers/admin_provider.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search users by username or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Users table/list
          Expanded(
            child: usersAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading users',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              data: (users) {
                // Filter users
                final filteredUsers = _searchQuery.isEmpty
                    ? users
                    : users
                        .where((user) =>
                            user.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            user.email.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                if (filteredUsers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (isDesktop) {
                  return _buildUsersTable(filteredUsers);
                } else {
                  return _buildUsersList(filteredUsers);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTable(List<UserProfileModel> users) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Username')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Joined')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: users.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user.username)),
              DataCell(Text(user.email, style: const TextStyle(fontSize: 12))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: user.isAdmin ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.isAdmin ? 'Admin' : 'User',
                    style: TextStyle(
                      color: user.isAdmin ? Colors.white : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              DataCell(Text(
                _formatDate(user.createdAt),
                style: const TextStyle(fontSize: 12),
              )),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: user.isBanned ? AppColors.error : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.isBanned ? 'Banned' : 'Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: Icon(user.isBanned ? Icons.check_circle : Icons.block),
                      tooltip: user.isAdmin ? 'Admin cannot be banned' : (user.isBanned ? 'Unban' : 'Ban'),
                      onPressed: user.isAdmin ? null : () => _toggleBanUser(user),
                      iconSize: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUsersList(List<UserProfileModel> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(user.isBanned ? Icons.check_circle : Icons.block),
                      color: user.isAdmin
                          ? AppColors.textHint
                          : (user.isBanned ? Colors.green : AppColors.error),
                      tooltip: user.isAdmin ? 'Admin cannot be banned' : (user.isBanned ? 'Unban' : 'Ban'),
                      onPressed: user.isAdmin ? null : () => _toggleBanUser(user),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user.isAdmin ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.isAdmin ? 'Admin' : 'User',
                        style: TextStyle(
                          color: user.isAdmin ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user.isBanned ? AppColors.error : Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.isBanned ? 'Banned' : 'Active',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Joined ${_formatDate(user.createdAt)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleBanUser(UserProfileModel user) {
    // Prevent banning admin accounts
    if (user.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin accounts cannot be banned'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.isBanned ? 'Unban User' : 'Ban User'),
        content: Text(
          user.isBanned
              ? 'Unban ${user.username}? They will be able to login again.'
              : 'Ban ${user.username}? They will not be able to login.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(adminRepositoryProvider).toggleBanUser(user.id, !user.isBanned);
                ref.invalidate(allUsersProvider);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(user.isBanned ? 'User unbanned' : 'User banned'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(user.isBanned ? 'Unban' : 'Ban'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
