import 'dart:convert';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/storage/storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _api;
  final StorageService _storage;

  AuthRepository(this._api, this._storage);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.login,
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );

    final data = response.data;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

    await _storage.setToken(token);
    await _storage.setUserJson(jsonEncode(user.toJson()));

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.register,
      data: {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );

    final data = response.data;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

    await _storage.setToken(token);
    await _storage.setUserJson(jsonEncode(user.toJson()));

    return user;
  }

  Future<UserModel?> getProfile() async {
    try {
      final response = await _api.get(ApiEndpoints.me);
      final data = response.data;
      if (data['user'] != null) {
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        await _storage.setUserJson(jsonEncode(user.toJson()));
        return user;
      }
    } catch (_) {
      // If network fails, try returning cached user
      final cachedJson = _storage.getUserJson();
      if (cachedJson != null) {
        return UserModel.fromJson(jsonDecode(cachedJson));
      }
    }
    return null;
  }

  Future<UserModel> updateProfile({
    String? name,
    int? dailyGoal,
    int? pomodoroLength,
    String? avatarColor,
  }) async {
    final response = await _api.put(
      ApiEndpoints.profile,
      data: {
        if (name != null) 'name': name.trim(),
        if (dailyGoal != null) 'dailyGoal': dailyGoal,
        if (pomodoroLength != null) 'pomodoroLength': pomodoroLength,
        if (avatarColor != null) 'avatarColor': avatarColor,
      },
    );

    final user = UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    await _storage.setUserJson(jsonEncode(user.toJson()));
    return user;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _api.put(
      ApiEndpoints.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> logout() async {
    await _storage.clearSession();
  }

  UserModel? getCachedUser() {
    final cached = _storage.getUserJson();
    if (cached != null) {
      try {
        return UserModel.fromJson(jsonDecode(cached));
      } catch (_) {}
    }
    return null;
  }

  bool isAuthenticated() {
    return _storage.getToken() != null && _storage.getToken()!.isNotEmpty;
  }
}
