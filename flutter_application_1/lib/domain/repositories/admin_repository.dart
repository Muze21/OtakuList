// lib/domain/repositories/admin_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/anime.dart';
import '../entities/profile.dart';
import '../../core/constants/anime_status.dart';
import '../../core/constants/roles.dart';

abstract class AdminRepository {
  // Anime Management
  Future<Either<Failure, Anime>> createAnime({
    required String title,
    String? synopsis,
    String? imageUrl,
    required int episodes,
    required List<String> genres,
    required AnimeStatus status,
    int? year,
    String? studio,
  });

  Future<Either<Failure, Anime>> updateAnime({
    required String id,
    String? title,
    String? synopsis,
    String? imageUrl,
    int? episodes,
    List<String>? genres,
    AnimeStatus? status,
    int? year,
    String? studio,
  });

  Future<Either<Failure, void>> deleteAnime(String id);

  // User Management
  Future<Either<Failure, List<Profile>>> getAllUsers();

  Future<Either<Failure, Profile>> updateUserRole({
    required String userId,
    required UserRole role,
  });

  Future<Either<Failure, void>> deleteUser(String userId);
}