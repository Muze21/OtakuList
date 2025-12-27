// lib/domain/use_cases/auth/register_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/profile.dart';
import '../../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, Profile>> call({
    required String email,
    required String password,
    required String username,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      username: username,
    );
  }
}