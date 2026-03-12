import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/profile_notifier.dart';
import '../models/asm.dart';
import '../models/salary_slip.dart';
import '../notifiers/auth_notifier.dart';
import '../services/profile/profile_services.dart';
import '../services/salary_slip/salary_slip_services.dart';
import 'auth_provider.dart';

/// Provider for profile state management
///
/// This provider manages the profile state throughout the app.
/// Use this to access profile data and trigger profile updates.

final profileServicesProvider = Provider<ProfileServices>((ref) {
  return ProfileServices();
});

final salarySlipServicesProvider = Provider<SalarySlipServices>((ref) {
  return SalarySlipServices();
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      final notifier = ProfileNotifier(
        ref.read(profileServicesProvider),
        ref.read(salarySlipServicesProvider),
      );

      ref.listen<AuthState>(authNotifierProvider, (previous, next) {
        notifier.syncAuthState(next);
      });

      notifier.syncAuthState(ref.read(authNotifierProvider));
      return notifier;
    });

/// Computed provider for getting the current profile
final currentProfileProvider = Provider<ASM?>((ref) {
  return ref.watch(profileNotifierProvider).profile;
});

/// Computed provider for checking if profile is loading
final isProfileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileNotifierProvider).isLoading;
});

/// Computed provider for getting profile error
final profileErrorProvider = Provider<String?>((ref) {
  return ref.watch(profileNotifierProvider).error;
});

final salarySlipProvider = Provider<SalarySlip?>((ref) {
  return ref.watch(profileNotifierProvider).salarySlip;
});

final isSalarySlipDownloadingProvider = Provider<bool>((ref) {
  return ref.watch(profileNotifierProvider).isSalarySlipDownloading;
});

final salarySlipErrorProvider = Provider<String?>((ref) {
  return ref.watch(profileNotifierProvider).salarySlipError;
});
