// lib/core/constants/roles.dart
enum UserRole {
  user('user'),
  admin('admin'),
  banned('banned');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }

  bool get isAdmin => this == UserRole.admin;
  bool get isBanned => this == UserRole.banned;
  bool get isUser => this == UserRole.user;
}