import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../cards/profile/profile_header_card.dart';
import '../../cards/profile/profile_options_card.dart';
import '../../widgets/app_bar.dart';
import '../../providers/profile_provider.dart';
import '../../routes/app_router.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final asmId = ref.read(authNotifierProvider).asmId;
      if (asmId != null && asmId.isNotEmpty) {
        ref
            .read(profileNotifierProvider.notifier)
            .loadProfile(asmId, forceRefresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final isSalarySlipDownloading = ref.watch(isSalarySlipDownloadingProvider);

    if (profileState.isLoading && profileState.profile == null) {
      return const Scaffold(
        appBar: MRAppBar(
          showBack: true,
          showActions: false,
          titleText: 'My Profile',
          subtitleText: 'Loading your profile',
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'My Profile',
        subtitleText: 'View and manage your profile',
      ),
      body: profileState.profile != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Card
                  ProfileHeaderCard(profile: profileState.profile!),
                  const SizedBox(height: 20),
                  // Profile Options Card
                  ProfileOptionsCard(
                    onUpdateProfile: () =>
                        context.push(AppRouter.updateProfile),
                    onAboutUs: () => context.push(AppRouter.aboutUs),
                    onContactSupport: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact Support feature coming soon'),
                        ),
                      );
                    },
                    onSalarySlip: () {
                      if (isSalarySlipDownloading) {
                        return;
                      }

                      ref
                          .read(profileNotifierProvider.notifier)
                          .downloadSalarySlipForCurrentAsm()
                          .then((success) {
                            if (!context.mounted) {
                              return;
                            }

                            final latestState = ref.read(
                              profileNotifierProvider,
                            );
                            final failureMessage = latestState.salarySlipError;
                            final successFile =
                                latestState.salarySlip?.localFilePath;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Salary slip downloaded and opened${successFile != null ? ': $successFile' : ''}'
                                      : (failureMessage ??
                                            'Unable to download salary slip right now.'),
                                ),
                              ),
                            );
                          });
                    },
                    onNotifications: () =>
                        context.push(AppRouter.notifications),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    profileState.error ?? 'No profile data available',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final asmId = authState.asmId;
                      if (asmId != null && asmId.isNotEmpty) {
                        ref
                            .read(profileNotifierProvider.notifier)
                            .loadProfile(asmId, forceRefresh: true);
                      } else {
                        ref
                            .read(profileNotifierProvider.notifier)
                            .refreshProfile();
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
    );
  }
}
