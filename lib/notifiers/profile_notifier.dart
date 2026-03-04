import 'package:flutter_riverpod/legacy.dart';
import '../models/asm.dart';

/// Profile state class
class ProfileState {
  final bool isLoading;
  final ASM? profile;
  final String? error;

  ProfileState({
    this.isLoading = false,
    this.profile,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    ASM? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

/// Profile notifier for managing profile state
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  /// Set profile data
  void setProfile(ASM profile) {
    state = state.copyWith(profile: profile, isLoading: false, error: null);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error
  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Update profile
  void updateProfile(ASM updatedProfile) {
    state = state.copyWith(profile: updatedProfile, error: null);
  }

  /// Clear profile
  void clearProfile() {
    state = ProfileState();
  }
}
