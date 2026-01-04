// lib/domain/use_cases/anime/get_anime_detail_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/anime.dart';
import '../../repositories/anime_repository.dart';

class GetAnimeDetailUseCase {
  final AnimeRepository repository;

  GetAnimeDetailUseCase(this.repository);

  Future<Either<Failure, Anime>> call(String id) async {
    return await repository.getAnimeById(id);
  }
}