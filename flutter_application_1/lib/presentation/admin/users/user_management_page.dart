// lib/presentation/admin/users/user_management_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // TODO: Get users from provider
    // final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 10, // TODO: Replace with actual user count
        itemBuilder: (context, index) {
          return _UserListItem(
            username: 'User $index',
            email: 'user$index@example.com',
            role: index == 0 ? 'admin' : 'user',
            isBanned: index % 5 == 0,
            onBanToggle: () {
              // TODO: Toggle ban status
            },
            onDelete: () {
              // TODO: Delete user
            },
          );
        },
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final String username;
  final String email;
  final String role;
  final bool isBanned;
  final VoidCallback onBanToggle;
  final VoidCallback onDelete;

  const _UserListItem({
    required this.username,
    required this.email,
    required this.role,
    required this.isBanned,
    required this.onBanToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: role == 'admin' ? Colors.orange : Colors.blue,
          child: Text(username[0].toUpperCase()),
        ),
        title: Text(username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(role.toUpperCase()),
                  backgroundColor: role == 'admin' 
                      ? Colors.orange[100] 
                      : Colors.blue[100],
                  labelStyle: const TextStyle(fontSize: 10),
                  padding: EdgeInsets.zero,
                ),
                if (isBanned) ...[
                  const SizedBox(width: 8),
                  const Chip(
                    label: Text('BANNED'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: onBanToggle,
              child: Row(
                children: [
                  Icon(isBanned ? Icons.check_circle : Icons.block),
                  const SizedBox(width: 8),
                  Text(isBanned ? 'Unban User' : 'Ban User'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: onDelete,
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete User', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}