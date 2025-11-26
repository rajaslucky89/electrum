import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electrum/src/features/auth/domain/user_model.dart';

class AuthRepository {
  final SharedPreferences _prefs;
  static const _userKey = 'user_data';
  static const _registeredUsersKey = 'registered_users';

  AuthRepository(this._prefs);

  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  User? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _prefs.remove(_userKey);
  }

  Future<void> registerUser(String name, String email, String password) async {
    final usersMap = _getRegisteredUsers();
    if (usersMap.containsKey(email)) {
      throw Exception('User already exists');
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    // Store user data + password. In a real app, NEVER store passwords in plain text.
    usersMap[email] = {
      'user': newUser.toJson(),
      'password': password,
    };

    await _prefs.setString(_registeredUsersKey, jsonEncode(usersMap));
    
    // Auto login after register
    await saveUser(newUser);
  }

  Future<User> verifyUser(String email, String password) async {
    final usersMap = _getRegisteredUsers();
    final userData = usersMap[email];

    if (userData == null) {
      throw Exception('User not found');
    }

    if (userData['password'] != password) {
      throw Exception('Invalid password');
    }

    final user = User.fromJson(userData['user']);
    await saveUser(user);
    return user;
  }

  Map<String, dynamic> _getRegisteredUsers() {
    final usersJson = _prefs.getString(_registeredUsersKey);
    if (usersJson == null) return {};
    return Map<String, dynamic>.from(jsonDecode(usersJson));
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepository(prefs);
});

final authStateProvider = NotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<User?> {
  late final AuthRepository _repo;

  @override
  User? build() {
    _repo = ref.watch(authRepositoryProvider);
    return _repo.getUser();
  }

  Future<void> login(String email, String password) async {
    state = await _repo.verifyUser(email, password);
  }

  Future<void> register(String name, String email, String password) async {
    await _repo.registerUser(name, email, password);
    state = _repo.getUser();
  }

  Future<void> logout() async {
    await _repo.logout();
    state = null;
  }
}
