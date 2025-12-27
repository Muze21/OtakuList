// lib/domain/use_cases/anime/get_anime_list_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/anime.dart';
import '../../repositories/anime_repository.dart';

class GetAnimeListUseCase {
  final AnimeRepository repository;

  GetAnimeListUseCase(this.repository);

  Future<Either<Failure, List<Anime>>> call({
    int page = 0,
    int limit = 20,
    String? search,
    String? genre,
  }) async {
    return await repository.getAnimeList(
      page: page,
      limit: limit,
      search: search,
      genre: genre,
    );
  }
}