// lib/presentation/auth/register/register_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/use_cases/auth/register_use_case.dart';
import '../../../config/providers.dart';

class RegisterState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  RegisterState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class RegisterController extends StateNotifier<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterController(this.registerUseCase) : super(RegisterState());

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await registerUseCase(
      email: email,
      username: username,
      password: password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (profile) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
      },
    );
  }

  void resetState() {
    state = RegisterState();
  }
}

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>((ref) {
  final registerUseCase = ref.watch(registerUseCaseProvider);
  return RegisterController(registerUseCase);
});