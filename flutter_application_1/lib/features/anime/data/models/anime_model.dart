import 'package:flutter_application_1/features/anime/domain/entities/anime_entity.dart';

/// Model untuk data Anime dari database (NEW - Supabase compatible)
class AnimeModel extends AnimeEntity {
  AnimeModel({
    required super.id,
    required super.title,
    required super.synopsis,
    required super.imageFileName,
    required super.episodes,
    required super.rating,
    required super.genres,
    required super.status,
    required super.year,
    required super.studio,
    required super.createdAt,
    required super.updatedAt,
  });

  // From Supabase JSON
  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      synopsis: json['synopsis'] as String,
      imageFileName: json['image_file_name'] as String? ?? '',
      episodes: json['episodes'] as int,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      genres: _parseGenres(json['genres']),
      status: json['status'] as String,
      year: json['year'] as int,
      studio: json['studio'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  // Helper to parse genres from either List or String array
  static List<String> _parseGenres(dynamic genresData) {
    if (genresData == null) return [];
    if (genresData is List) {
      return genresData.cast<String>();
    }
    if (genresData is String) {
      // Handle PostgreSQL array format: {Genre1,Genre2,...}
      return genresData
          .replaceAll('{', '')
          .replaceAll('}', '')
          .split(',')
          .map((g) => g.trim())
          .where((g) => g.isNotEmpty)
          .toList();
    }
    return [];
  }

  // To Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'image_file_name': imageFileName,
      'episodes': episodes,
      'rating': rating,
      'genres': genres,
      'status': status,
      'year': year,
      'studio': studio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // For Anime Creation (Admin) - tidak kirim id, created_at, updated_at
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'synopsis': synopsis,
      'image_file_name': imageFileName,
      'episodes': episodes,
      'genres': genres,
      'status': status,
      'year': year,
      'studio': studio,
    };
  }

  // copyWith for updates
  AnimeModel copyWith({
    String? id,
    String? title,
    String? synopsis,
    String? imageFileName,
    int? episodes,
    double? rating,
    List<String>? genres,
    String? status,
    int? year,
    String? studio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AnimeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      synopsis: synopsis ?? this.synopsis,
      imageFileName: imageFileName ?? this.imageFileName,
      episodes: episodes ?? this.episodes,
      rating: rating ?? this.rating,
      genres: genres ?? this.genres,
      status: status ?? this.status,
      year: year ?? this.year,
      studio: studio ?? this.studio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// OLD MODEL - untuk backward compatibility dengan UI yang sudah ada
/// BISA DIHAPUS setelah semua UI diupdate menggunakan AnimeModel
@Deprecated('Use AnimeModel instead')
class Anime {
  final int id;
  final String title;
  final String? synopsis;
  final String? coverImageUrl;
  final String status;
  final int? totalEpisodes;
  final double avgRating;
  final List<String> genres;
  final String? studio;

  Anime({
    required this.id,
    required this.title,
    this.synopsis,
    this.coverImageUrl,
    required this.status,
    this.totalEpisodes,
    required this.avgRating,
    required this.genres,
    this.studio,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      title: json['title'],
      synopsis: json['synopsis'],
      coverImageUrl: json['image_file_name'],
      status: json['status'],
      totalEpisodes: json['total_episodes'],
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      genres: List<String>.from(json['genres'] ?? []),
      studio: json['studio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'image_file_name': coverImageUrl,
      'status': status,
      'total_episodes': totalEpisodes,
      'avg_rating': avgRating,
      'genres': genres,
      'studio': studio,
    };
  }
}

/// OLD MODEL - UserAnimeList untuk backward compatibility
@Deprecated('Use UserAnimeModel instead')
class UserAnimeList {
  final int id;
  final int animeId;
  final Anime anime;
  final String listStatus;
  final int progressEpisode;
  final int? score;
  final bool isFavorite;

  UserAnimeList({
    required this.id,
    required this.animeId,
    required this.anime,
    required this.listStatus,
    required this.progressEpisode,
    this.score,
    required this.isFavorite,
  });

  factory UserAnimeList.fromJson(Map<String, dynamic> json) {
    return UserAnimeList(
      id: json['id'],
      animeId: json['anime_id'],
      anime: Anime.fromJson(json['anime']),
      listStatus: json['list_status'],
      progressEpisode: json['progress_episode'],
      score: json['score'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  double get progressPercentage {
    if (anime.totalEpisodes == null || anime.totalEpisodes == 0) return 0;
    return (progressEpisode / anime.totalEpisodes!) * 100;
  }
}