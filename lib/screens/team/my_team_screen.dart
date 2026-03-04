import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../cards/team/team_card.dart';
import '../../providers/team_provider.dart';
import '../../widgets/bottom_nav_bar.dart';

class MyTeamScreen extends ConsumerWidget {
  const MyTeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(allTeamsProvider);
    final isLoading = ref.watch(isTeamsLoadingProvider);

    return Scaffold(
      appBar: MRAppBar(
        showBack: false,
        showActions: false,
        titleText: 'My Team',
        subtitleText: 'Manage your sales teams',
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : teams.isEmpty
              ? const Center(
                  child: Text('No teams available'),
                )
              : ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return TeamCard(
                      team: teams[index],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${teams[index].name} selected')),
                        );
                      },
                    );
                  },
                ),
      bottomNavigationBar: const MRBottomNavBar(currentIndex: 1),
    );
  }
}
