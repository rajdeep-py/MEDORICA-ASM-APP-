import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asm.dart';
import '../services/profile/auth_services.dart';

/// Authentication state class
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final ASM? user;
  final String? asmId;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.asmId,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    ASM? user,
    String? asmId,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      asmId: asmId ?? this.asmId,
      error: error,
    );
  }
}

/// Authentication notifier for managing auth state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authServices) : super(AuthState());

  final AuthServices _authServices;

  static const String _sessionLoggedInKey = 'session_logged_in';
  static const String _sessionAsmIdKey = 'session_asm_id';

  /// Login with phone number and password
  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trimmedPhone = phone.trim();
      if (trimmedPhone.isEmpty) {
        state = AuthState(error: 'Phone number is required.');
        return;
      }

      if (password.isEmpty) {
        state = AuthState(error: 'Password is required.');
        return;
      }

      final user = await _authServices.login(
        phone: trimmedPhone,
        password: password,
      );
      final asmId = user.asmId ?? user.id;

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        asmId: asmId,
        error: null,
      );
      await _persistSession(asmId: asmId);
    } catch (error) {
      state = AuthState(error: _readErrorMessage(error));
    }
  }

  Future<void> syncAuthenticatedUser(ASM profile) async {
    final asmId = profile.asmId ?? profile.id;
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: profile,
      asmId: asmId,
      error: null,
    );
    await _persistSession(asmId: asmId);
  }

  Future<bool> restoreSession() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final preferences = await SharedPreferences.getInstance();
      final isLoggedIn = preferences.getBool(_sessionLoggedInKey) ?? false;
      final asmId = preferences.getString(_sessionAsmIdKey);

      if (!isLoggedIn || asmId == null || asmId.isEmpty) {
        state = AuthState();
        return false;
      }

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        asmId: asmId,
        error: null,
      );
      return true;
    } catch (_) {
      state = AuthState();
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    state = AuthState();
    await _clearSession();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  /// Get current user
  ASM? get currentUser => state.user;

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }

  Future<void> _persistSession({required String asmId}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_sessionLoggedInKey, true);
    await preferences.setString(_sessionAsmIdKey, asmId);
  }

  Future<void> _clearSession() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_sessionLoggedInKey);
    await preferences.remove(_sessionAsmIdKey);
  }
}
