class AnimeEntity {
  final String id;
  final String title;
  final String synopsis;
  final String imageFileName;
  final int episodes;
  final double rating;
  final List<String> genres;
  final String status;
  final int year;
  final String studio;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnimeEntity({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.imageFileName,
    required this.episodes,
    required this.rating,
    required this.genres,
    required this.status,
    required this.year,
    required this.studio,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOngoing => status == 'Ongoing';
  bool get isCompleted => status == 'Completed';
  bool get isUpcoming => status == 'Upcoming';

  String get imagePath => 'assets/images/anime/$imageFileName';
}