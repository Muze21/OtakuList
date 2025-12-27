// lib/data/models/anime_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/anime.dart';
import '../../core/constants/anime_status.dart';

part 'anime_model.freezed.dart';
part 'anime_model.g.dart';

@freezed
class AnimeModel with _$AnimeModel {
  const AnimeModel._();

  const factory AnimeModel({
    required String id,
    required String title,
    String? synopsis,
    @JsonKey(name: 'image_url') String? imageUrl,
    required int episodes,
    required double rating,
    required List<String> genres,
    required String status,
    int? year,
    String? studio,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _AnimeModel;

  factory AnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeModelFromJson(json);

  Anime toEntity() {
    return Anime(
      id: id,
      title: title,
      synopsis: synopsis,
      imageUrl: imageUrl,
      episodes: episodes,
      rating: rating,
      genres: genres,
      status: AnimeStatus.fromString(status),
      year: year,
      studio: studio,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory AnimeModel.fromEntity(Anime anime) {
    return AnimeModel(
      id: anime.id,
      title: anime.title,
      synopsis: anime.synopsis,
      imageUrl: anime.imageUrl,
      episodes: anime.episodes,
      rating: anime.rating,
      genres: anime.genres,
      status: anime.status.value,
      year: anime.year,
      studio: anime.studio,
      createdAt: anime.createdAt.toIso8601String(),
      updatedAt: anime.updatedAt?.toIso8601String(),
    );
  }
}