import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cards/profile/profile_header_card.dart';
import '../../cards/profile/profile_options_card.dart';
import '../../widgets/app_bar.dart';
import '../../providers/profile_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

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
                    onUpdateProfile: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Update Profile feature coming soon')),
                      );
                    },
                    onAboutUs: () => context.push('/about-us'),
                    onContactSupport: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contact Support feature coming soon')),
                      );
                    },
                    onSalarySlip: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Salary Slip download feature coming soon')),
                      );
                    },
                    onNotifications: () => context.push('/notifications'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No profile data available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
    );
  }
}
