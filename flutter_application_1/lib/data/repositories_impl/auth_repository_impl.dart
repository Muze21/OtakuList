// lib/data/repositories_impl/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart' as app_exceptions;
import '../../core/errors/failures.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Profile>> login({
    required String email,
    required String password,
  }) async {
    try {
      final profileModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(profileModel.toEntity());
    } on app_exceptions.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final profileModel = await remoteDataSource.register(
        email: email,
        password: password,
        username: username,
      );
      return Right(profileModel.toEntity());
    } on app_exceptions.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on app_exceptions.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> getCurrentUser() async {
    try {
      final profileModel = await remoteDataSource.getCurrentUser();
      if (profileModel == null) {
        return Left(AuthFailure('User not authenticated'));
      }
      return Right(profileModel.toEntity());
    } on app_exceptions.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final profileModel = await remoteDataSource.updateProfile(
        username: username,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      return Right(profileModel.toEntity());
    } on app_exceptions.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<Profile?> get authStateChanges {
    return remoteDataSource.authStateChanges.map(
      (profileModel) => profileModel?.toEntity(),
    );
  }
}