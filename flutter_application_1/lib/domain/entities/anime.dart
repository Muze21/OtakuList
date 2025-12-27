// lib/domain/entities/anime.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/anime_status.dart';

part 'anime.freezed.dart';

@freezed
class Anime with _$Anime {
  const factory Anime({
    required String id,
    required String title,
    String? synopsis,
    String? imageUrl,
    required int episodes,
    required double rating,
    required List<String> genres,
    required AnimeStatus status,
    int? year,
    String? studio,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Anime;
}