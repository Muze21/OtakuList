// lib/domain/use_cases/auth/login_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/profile.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, Profile>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}