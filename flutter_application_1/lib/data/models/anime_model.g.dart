// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimeModelImpl _$$AnimeModelImplFromJson(Map<String, dynamic> json) =>
    _$AnimeModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      synopsis: json['synopsis'] as String?,
      imageUrl: json['image_url'] as String?,
      episodes: (json['episodes'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      genres: (json['genres'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      year: (json['year'] as num?)?.toInt(),
      studio: json['studio'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$AnimeModelImplToJson(_$AnimeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'synopsis': instance.synopsis,
      'image_url': instance.imageUrl,
      'episodes': instance.episodes,
      'rating': instance.rating,
      'genres': instance.genres,
      'status': instance.status,
      'year': instance.year,
      'studio': instance.studio,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
