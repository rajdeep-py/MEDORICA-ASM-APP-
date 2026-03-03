import 'package:flutter_riverpod/legacy.dart';
import '../models/asm.dart';

/// Authentication state class
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final ASM? user;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    ASM? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

/// Authentication notifier for managing auth state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  /// Login with phone number and password
  /// Accepts any phone number and password for frontend testing
  Future<void> login(String phone, String password) async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Validate phone number
      if (phone.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Phone number is required.',
        );
        return;
      }

      // Validate password
      if (password.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Password is required.',
        );
        return;
      }

      // Clean phone number (remove spaces, dashes, etc.)
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

      // Generate user from phone number for frontend testing
      final user = ASM(
        id: cleanPhone.hashCode.toString(),
        name: 'ASM User',
        phone: cleanPhone,
        email: 'asm_$cleanPhone@medorica.com',
        region: 'Default Region',
        territory: 'Default Territory',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      // Update state with authenticated user
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred during login. Please try again.',
      );
    }
  }

  /// Logout current user
  void logout() {
    state = AuthState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  /// Get current user
  ASM? get currentUser => state.user;
}
