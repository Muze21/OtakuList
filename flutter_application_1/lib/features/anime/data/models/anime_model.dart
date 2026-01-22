class Anime {
  final int id;
  final String title;
  final String? synopsis;
  final String? coverImageUrl;
  final String status; // 'ongoing', 'completed', 'hiatus'
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
      coverImageUrl: json['cover_image_url'],
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
      'cover_image_url': coverImageUrl,
      'status': status,
      'total_episodes': totalEpisodes,
      'avg_rating': avgRating,
      'genres': genres,
      'studio': studio,
    };
  }
}

class UserAnimeList {
  final int id;
  final int animeId;
  final Anime anime;
  final String listStatus; // 'watching', 'completed', 'planned', 'dropped'
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