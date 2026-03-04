import 'package:flutter_riverpod/legacy.dart';
import '../models/team.dart';

/// Team state class
class TeamState {
  final bool isLoading;
  final List<Team> teams;
  final String? error;

  TeamState({
    this.isLoading = false,
    this.teams = const [],
    this.error,
  });

  TeamState copyWith({
    bool? isLoading,
    List<Team>? teams,
    String? error,
  }) {
    return TeamState(
      isLoading: isLoading ?? this.isLoading,
      teams: teams ?? this.teams,
      error: error,
    );
  }
}

/// Team notifier for managing team state
class TeamNotifier extends StateNotifier<TeamState> {
  TeamNotifier() : super(TeamState()) {
    _initializeMockTeams();
  }

  /// Initialize with mock teams (for demo purposes)
  void _initializeMockTeams() {
    final mockTeams = [
      Team(
        id: '1',
        name: 'Sales Team Alpha',
        headquarter: 'Mumbai',
        territory: 'Western Region',
        description: 'Responsible for pharmaceutical sales in Western India including Gujarat, Maharashtra, and Goa.',
        groupLink: 'https://chat.whatsapp.com/sales-team-alpha-2024',
        members: ['John Doe', 'Jane Smith', 'Mike Johnson', 'Sarah Williams'],
      ),
      Team(
        id: '2',
        name: 'Sales Team Beta',
        headquarter: 'Delhi',
        territory: 'Northern Region',
        description: 'Manages sales operations across North India covering Delhi, Punjab, Haryana, and Himachal Pradesh.',
        groupLink: 'https://chat.whatsapp.com/sales-team-beta-2024',
        members: ['Alex Kumar', 'Priya Singh', 'Rajesh Patel'],
      ),
      Team(
        id: '3',
        name: 'Sales Team Gamma',
        headquarter: 'Bangalore',
        territory: 'Southern Region',
        description: 'Handles distribution and sales in South India including Karnataka, Tamil Nadu, Telangana, and Andhra Pradesh.',
        groupLink: 'https://chat.whatsapp.com/sales-team-gamma-2024',
        members: ['Amit Sharma', 'Neha Reddy', 'Vikram Desai', 'Anjali Nair', 'Deepak Kumar'],
      ),
    ];
    state = state.copyWith(teams: mockTeams);
  }

  /// Add team
  void addTeam(Team team) {
    final currentTeams = [...state.teams, team];
    state = state.copyWith(teams: currentTeams);
  }

  /// Update team
  void updateTeam(Team team) {
    final updatedTeams = state.teams.map((t) => t.id == team.id ? team : t).toList();
    state = state.copyWith(teams: updatedTeams);
  }

  /// Delete team
  void deleteTeam(String teamId) {
    final filteredTeams = state.teams.where((t) => t.id != teamId).toList();
    state = state.copyWith(teams: filteredTeams);
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
}
