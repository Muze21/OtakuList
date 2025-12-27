// lib/domain/entities/profile.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/roles.dart';

part 'profile.freezed.dart';


@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String email,
    required String username,
    String? avatarUrl,
    String? bio,
    required UserRole role,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Profile;
}