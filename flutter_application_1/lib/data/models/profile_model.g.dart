// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'role': instance.role,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
