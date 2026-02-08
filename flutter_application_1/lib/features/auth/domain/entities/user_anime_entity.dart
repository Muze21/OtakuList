class UserAnimeEntity {
  final String id;
  final String userId;
  final String animeId;
  final String status;
  final int watchedEpisodes;
  final double? userRating;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAnimeEntity({
    required this.id,
    required this.userId,
    required this.animeId,
    required this.status,
    required this.watchedEpisodes,
    this.userRating,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isWatching => status == 'Watching';
  bool get isCompleted => status == 'Completed';
  bool get isOnHold => status == 'On Hold';
  bool get isDropped => status == 'Dropped';
  bool get isPlanToWatch => status == 'Plan to Watch';
}