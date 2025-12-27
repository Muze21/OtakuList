import '../../core/constants/list_status.dart';
import 'anime.dart'; // Import Anime entity

class UserAnime {
  final String id;
  final String userId;
  final String animeId;
  final ListStatus status;
  final int? episodesWatched;
  final double? userRating;
  final DateTime addedAt;
  final DateTime? updatedAt;
  final Anime? anime; // Relasi ke Anime (optional, untuk JOIN query)

  const UserAnime({
    required this.id,
    required this.userId,
    required this.animeId,
    required this.status,
    this.episodesWatched,
    this.userRating,
    required this.addedAt,
    this.updatedAt,
    this.anime,
  });

  UserAnime copyWith({
    String? id,
    String? userId,
    String? animeId,
    ListStatus? status,
    int? episodesWatched,
    double? userRating,
    DateTime? addedAt,
    DateTime? updatedAt,
    Anime? anime,
  }) {
    return UserAnime(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      animeId: animeId ?? this.animeId,
      status: status ?? this.status,
      episodesWatched: episodesWatched ?? this.episodesWatched,
      userRating: userRating ?? this.userRating,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      anime: anime ?? this.anime,
    );
  }
}
