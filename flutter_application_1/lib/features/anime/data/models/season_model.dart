class Season {
  final String season; // 'fall', 'winter', 'spring', 'summer'
  final int year;
  
  Season({required this.season, required this.year});
  
  String get displayName => '$season $year'.toUpperCase();
  
  static List<Season> getUpcomingSeasons() {
    return [
      Season(season: 'Fall', year: 2024),
      Season(season: 'Winter', year: 2025),
      Season(season: 'Spring', year: 2025),
      Season(season: 'Summer', year: 2025),
    ];
  }
}

class AnimeCard {
  final int id;
  final String title;
  final String? coverImageUrl;
  final String releaseDate;
  final int episodeCount;
  final int durationMinutes;
  final List<String> genres;
  final String synopsis;
  final String studio;
  final double avgRating;
  final int totalRatings;
  final String type; // 'TV', 'ONA', 'OVA', 'Movie', 'Special'
  final String status; // 'ongoing', 'completed', 'upcoming'
  
  AnimeCard({
    required this.id,
    required this.title,
    this.coverImageUrl,
    required this.releaseDate,
    required this.episodeCount,
    required this.durationMinutes,
    required this.genres,
    required this.synopsis,
    required this.studio,
    required this.avgRating,
    required this.totalRatings,
    required this.type,
    required this.status,
  });
  
  factory AnimeCard.fromJson(Map<String, dynamic> json) {
    return AnimeCard(
      id: json['id'],
      title: json['title'],
      coverImageUrl: json['cover_image_url'],
      releaseDate: json['release_date'],
      episodeCount: json['episode_count'],
      durationMinutes: json['duration_minutes'],
      genres: List<String>.from(json['genres'] ?? []),
      synopsis: json['synopsis'],
      studio: json['studio'],
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      type: json['type'],
      status: json['status'],
    );
  }
}