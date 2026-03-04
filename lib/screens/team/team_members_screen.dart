import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_bar.dart';
import '../../cards/team_member/team_member_card.dart';
import '../../providers/team_member_provider.dart';

class TeamMembersScreen extends ConsumerWidget {
  final String teamId;
  final String teamName;

  const TeamMembersScreen({
    super.key,
    required this.teamId,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMembers = ref.watch(allTeamMembersProvider);
    final isLoading = ref.watch(isTeamMembersLoadingProvider);
    
    // Filter members by team ID
    final teamMembers = allMembers.where((m) => m.teamId == teamId).toList();

    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: teamName,
        subtitleText: '${teamMembers.length} members',
        onBack: () => context.pop(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : teamMembers.isEmpty
              ? const Center(
                  child: Text('No team members available'),
                )
              : ListView.builder(
                  itemCount: teamMembers.length,
                  itemBuilder: (context, index) {
                    return TeamMemberCard(
                      member: teamMembers[index],
                      onTap: () {
                        ref.read(selectedTeamMemberProvider);
                        context.push(
                          '/team-member-detail/${teamMembers[index].id}',
                          extra: teamMembers[index],
                        );
                      },
                    );
                  },
                ),
    );
  }
}
