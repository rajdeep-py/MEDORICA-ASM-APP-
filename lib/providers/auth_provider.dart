import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/auth_notifier.dart';

/// Provider for authentication state management
/// 
/// This provider manages the authentication state throughout the app.
/// Use this to access auth state and trigger login/logout actions.

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
