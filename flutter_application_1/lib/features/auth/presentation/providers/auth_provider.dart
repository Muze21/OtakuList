import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/data/models/user_profile_model.dart';

// ========== PROVIDERS ==========

/// Auth Remote Datasource Provider
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource();
});

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDatasource = ref.read(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(remoteDatasource);
});

/// Current User Provider (StateNotifier)
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserProfileModel?>>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return CurrentUserNotifier(repository);
});

/// Auth State Notifier Provider (for login/register operations)
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  final currentUserNotifier = ref.read(currentUserProvider.notifier);
  return AuthStateNotifier(repository, currentUserNotifier);
});

// ========== STATE CLASSES ==========

/// Auth State
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// ========== NOTIFIERS ==========

/// Current User State Notifier
class CurrentUserNotifier extends StateNotifier<AsyncValue<UserProfileModel?>> {
  final AuthRepository _repository;

  CurrentUserNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }

  /// Load current user on init
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Refresh current user
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadCurrentUser();
  }

  /// Set user (after login/register)
  void setUser(UserProfileModel user) {
    state = AsyncValue.data(user);
  }

  /// Clear user (after logout)
  void clearUser() {
    state = const AsyncValue.data(null);
  }

  /// Update user profile
  Future<void> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    try {
      final updatedUser = await _repository.updateProfile(
        userId: currentUser.id,
        username: username,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      state = AsyncValue.data(updatedUser);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Check if user is admin
  bool get isAdmin {
    final user = state.value;
    return user?.isAdmin ?? false;
  }

  /// Check if user is logged in
  bool get isLoggedIn {
    return state.value != null;
  }
}

/// Auth State Notifier (for login/register operations)
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final CurrentUserNotifier _currentUserNotifier;

  AuthStateNotifier(this._repository, this._currentUserNotifier) : super(AuthState());

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      // Check if username exists
      final usernameExists = await _repository.isUsernameExists(username);
      if (usernameExists) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Username already taken',
        );
        return;
      }

      // Register
      final user = await _repository.register(
        email: email,
        password: password,
        username: username,
      );

      _currentUserNotifier.setUser(user);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e),
      );
    }
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );

      _currentUserNotifier.setUser(user);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e),
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _repository.logout();
      _currentUserNotifier.clearUser();
      state = AuthState(); // Reset state
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e),
      );
    }
  }

  /// Reset state (clear errors)
  void resetState() {
    state = AuthState();
  }

  /// Extract user-friendly error message
  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Print full error for debugging
    print('[AUTH ERROR] $error');
    
    if (errorString.contains('invalid login credentials') || errorString.contains('invalid email')) {
      return 'Invalid email or password';
    } else if (errorString.contains('email not confirmed')) {
      return 'Please verify your email first';
    } else if (errorString.contains('user already registered')) {
      return 'Email already in use';
    } else if (errorString.contains('banned')) {
      return 'Your account has been banned';
    } else if (errorString.contains('weak password')) {
      return 'Password is too weak. Use at least 6 characters';
    } else if (errorString.contains('password')) {
      return 'Password must be at least 6 characters';
    } else if (errorString.contains('duplicate key')) {
      return 'This email or username is already registered';
    } else if (errorString.contains('not found')) {
      return 'User not found';
    } else if (errorString.contains('network')) {
      return 'Network error. Please check your connection';
    }
    
    // Return first 100 chars of error (sanitized)
    final msg = errorString.replaceAll('exception: ', '').trim();
    return msg.length > 100 ? '${msg.substring(0, 100)}...' : msg;
  }
}

// ========== HELPER PROVIDERS ==========

/// Check if user is admin
final isAdminProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.value?.isAdmin ?? false;
});

/// Check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.value != null;
});