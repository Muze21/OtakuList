class UserAnimeEntity {
	final String id;
	final String userId;
	final String animeId;
	final String status;
	final int watchedEpisodes;
	final double? userRating;
	final String? notes;
	final DateTime createdAt;
	final DateTime? updatedAt;

	const UserAnimeEntity({
		required this.id,
		required this.userId,
		required this.animeId,
		required this.status,
		required this.watchedEpisodes,
		this.userRating,
		this.notes,
		required this.createdAt,
		this.updatedAt,
	});
}
