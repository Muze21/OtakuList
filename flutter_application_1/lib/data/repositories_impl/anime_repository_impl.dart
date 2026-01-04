// lib/data/repositories_impl/anime_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/user_anime.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/anime_repository.dart';
import '../../core/constants/list_status.dart';
import '../data_sources/remote/anime_remote_data_source.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  final AnimeRemoteDataSource remoteDataSource;

  AnimeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Anime>>> getAnimeList({
    int page = 0,
    int limit = 20,
    String? search,
    String? genre,
  }) async {
    try {
      final models = await remoteDataSource.getAnimeList(
        page: page,
        limit: limit,
        search: search,
        genre: genre,
      );
      
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Anime>> getAnimeById(String id) async {
    try {
      final model = await remoteDataSource.getAnimeById(id);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // TODO: Implement other methods later
  @override
  Future<Either<Failure, List<UserAnime>>> getUserAnimeList({
    ListStatus? status,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserAnime>> addToList({
    required String animeId,
    required ListStatus status,
    int? watchedEpisodes,
    double? rating,
    String? notes,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserAnime>> updateListEntry({
    required String id,
    ListStatus? status,
    int? watchedEpisodes,
    double? rating,
    String? notes,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeFromList(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Review>>> getAnimeReviews(String animeId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Review>> addReview({
    required String animeId,
    required String content,
    required double rating,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    throw UnimplementedError();
  }
}