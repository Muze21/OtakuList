// lib/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, Profile>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Profile>> register({
    required String email,
    required String password,
    required String username,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, Profile>> getCurrentUser();

  Future<Either<Failure, Profile>> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  });

  Stream<Profile?> get authStateChanges;
}