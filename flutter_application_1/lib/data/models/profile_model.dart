// lib/data/models/profile_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/profile.dart';
import '../../core/constants/roles.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';


@freezed
class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    required String id,
    required String email,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? bio,
    required String role,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Profile toEntity() {
    return Profile(
      id: id,
      email: email,
      username: username,
      avatarUrl: avatarUrl,
      bio: bio,
      role: UserRole.fromString(role),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      email: profile.email,
      username: profile.username,
      avatarUrl: profile.avatarUrl,
      bio: profile.bio,
      role: profile.role.value,
      createdAt: profile.createdAt.toIso8601String(),
      updatedAt: profile.updatedAt?.toIso8601String(),
    );
  }
}