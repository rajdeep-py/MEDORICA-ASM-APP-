import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/team_member_notifier.dart';
import '../models/team_member.dart';

/// Provider for team member state management
final teamMemberNotifierProvider = StateNotifierProvider<TeamMemberNotifier, TeamMemberState>(
  (ref) => TeamMemberNotifier(),
);

/// Computed provider for getting all team members
final allTeamMembersProvider = Provider<List<TeamMember>>((ref) {
  return ref.watch(teamMemberNotifierProvider).members;
});

/// Computed provider for getting selected team member
final selectedTeamMemberProvider = Provider<TeamMember?>((ref) {
  return ref.watch(teamMemberNotifierProvider).selectedMember;
});

/// Computed provider for checking if team members are loading
final isTeamMembersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(teamMemberNotifierProvider).isLoading;
});

/// Computed provider for getting team member error
final teamMemberErrorProvider = Provider<String?>((ref) {
  return ref.watch(teamMemberNotifierProvider).error;
});
