// lib/domain/repositories/anime_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/anime.dart';
import '../entities/user_anime.dart';
import '../entities/review.dart';
import '../../core/constants/list_status.dart';

abstract class AnimeRepository {
  // Anime CRUD
  Future<Either<Failure, List<Anime>>> getAnimeList({
    int page = 0,
    int limit = 20,
    String? search,
    String? genre,
  });

  Future<Either<Failure, Anime>> getAnimeById(String id);

  // User's Anime List
  Future<Either<Failure, List<UserAnime>>> getUserAnimeList({
    ListStatus? status,
  });

  Future<Either<Failure, UserAnime>> addToList({
    required String animeId,
    required ListStatus status,
    int? watchedEpisodes,
    double? rating,
    String? notes,
  });

  Future<Either<Failure, UserAnime>> updateListEntry({
    required String id,
    ListStatus? status,
    int? watchedEpisodes,
    double? rating,
    String? notes,
  });

  Future<Either<Failure, void>> removeFromList(String id);

  // Reviews
  Future<Either<Failure, List<Review>>> getAnimeReviews(String animeId);

  Future<Either<Failure, Review>> addReview({
    required String animeId,
    required String content,
    required double rating,
  });

  Future<Either<Failure, void>> deleteReview(String reviewId);
}