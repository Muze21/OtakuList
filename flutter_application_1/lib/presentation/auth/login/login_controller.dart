// lib/presentation/auth/login/login_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/use_cases/auth/login_use_case.dart';
import '../../../config/providers.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  LoginState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class LoginController extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;

  LoginController(this.loginUseCase) : super(LoginState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await loginUseCase(email: email, password: password);

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
    state = LoginState();
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return LoginController(loginUseCase);
});