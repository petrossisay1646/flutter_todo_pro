import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import 'storage_provider.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(AuthState(status: AuthStatus.initial)) {
    checkSession();
  }

  Future<void> checkSession() async {
    final hasToken = _repo.isAuthenticated();
    if (!hasToken) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    final cachedUser = _repo.getCachedUser();
    if (cachedUser != null) {
      state = state.copyWith(status: AuthStatus.authenticated, user: cachedUser);
    }

    // Refresh profile in background
    try {
      final user = await _repo.getProfile();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else if (cachedUser == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (_) {
      if (cachedUser == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repo.login(email: email, password: password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repo.register(name: name, email: email, password: password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    int? dailyGoal,
    int? pomodoroLength,
    String? avatarColor,
  }) async {
    try {
      final updated = await _repo.updateProfile(
        name: name,
        dailyGoal: dailyGoal,
        pomodoroLength: pomodoroLength,
        avatarColor: avatarColor,
      );
      state = state.copyWith(user: updated);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      await _repo.changePassword(currentPassword: currentPassword, newPassword: newPassword);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
