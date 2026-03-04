import 'package:flutter_riverpod/legacy.dart';
import '../models/team_member.dart';

/// Team Member state class
class TeamMemberState {
  final bool isLoading;
  final List<TeamMember> members;
  final TeamMember? selectedMember;
  final String? error;

  TeamMemberState({
    this.isLoading = false,
    this.members = const [],
    this.selectedMember,
    this.error,
  });

  TeamMemberState copyWith({
    bool? isLoading,
    List<TeamMember>? members,
    TeamMember? selectedMember,
    String? error,
  }) {
    return TeamMemberState(
      isLoading: isLoading ?? this.isLoading,
      members: members ?? this.members,
      selectedMember: selectedMember ?? this.selectedMember,
      error: error,
    );
  }
}

/// Team Member notifier for managing team member state
class TeamMemberNotifier extends StateNotifier<TeamMemberState> {
  TeamMemberNotifier() : super(TeamMemberState()) {
    _initializeMockMembers();
  }

  /// Initialize with mock team members
  void _initializeMockMembers() {
    final mockMembers = [
      // Sales Team Alpha members
      TeamMember(
        id: '1',
        name: 'John Doe',
        phone: '+91 9876543210',
        altPhone: '+91 9876543211',
        email: 'john.doe@medorica.com',
        photoUrl: null,
        headquarter: 'Mumbai',
        territories: ['Gujarat', 'Maharashtra'],
        teamId: '1',
      ),
      TeamMember(
        id: '2',
        name: 'Jane Smith',
        phone: '+91 9876543212',
        altPhone: '+91 9876543213',
        email: 'jane.smith@medorica.com',
        photoUrl: null,
        headquarter: 'Mumbai',
        territories: ['Goa', 'Karnataka'],
        teamId: '1',
      ),
      TeamMember(
        id: '3',
        name: 'Mike Johnson',
        phone: '+91 9876543214',
        altPhone: '+91 9876543215',
        email: 'mike.johnson@medorica.com',
        photoUrl: null,
        headquarter: 'Mumbai',
        territories: ['Maharashtra'],
        teamId: '1',
      ),
      TeamMember(
        id: '4',
        name: 'Sarah Williams',
        phone: '+91 9876543216',
        altPhone: '+91 9876543217',
        email: 'sarah.williams@medorica.com',
        photoUrl: null,
        headquarter: 'Mumbai',
        territories: ['Gujarat', 'Goa'],
        teamId: '1',
      ),
      // Sales Team Beta members
      TeamMember(
        id: '5',
        name: 'Alex Kumar',
        phone: '+91 9876543218',
        altPhone: '+91 9876543219',
        email: 'alex.kumar@medorica.com',
        photoUrl: null,
        headquarter: 'Delhi',
        territories: ['Delhi', 'Haryana'],
        teamId: '2',
      ),
      TeamMember(
        id: '6',
        name: 'Priya Singh',
        phone: '+91 9876543220',
        altPhone: '+91 9876543221',
        email: 'priya.singh@medorica.com',
        photoUrl: null,
        headquarter: 'Delhi',
        territories: ['Punjab', 'Himachal Pradesh'],
        teamId: '2',
      ),
      TeamMember(
        id: '7',
        name: 'Rajesh Patel',
        phone: '+91 9876543222',
        altPhone: '+91 9876543223',
        email: 'rajesh.patel@medorica.com',
        photoUrl: null,
        headquarter: 'Delhi',
        territories: ['Delhi', 'Uttar Pradesh'],
        teamId: '2',
      ),
      // Sales Team Gamma members
      TeamMember(
        id: '8',
        name: 'Amit Sharma',
        phone: '+91 9876543224',
        altPhone: '+91 9876543225',
        email: 'amit.sharma@medorica.com',
        photoUrl: null,
        headquarter: 'Bangalore',
        territories: ['Karnataka'],
        teamId: '3',
      ),
      TeamMember(
        id: '9',
        name: 'Neha Reddy',
        phone: '+91 9876543226',
        altPhone: '+91 9876543227',
        email: 'neha.reddy@medorica.com',
        photoUrl: null,
        headquarter: 'Bangalore',
        territories: ['Tamil Nadu', 'Andhra Pradesh'],
        teamId: '3',
      ),
      TeamMember(
        id: '10',
        name: 'Vikram Desai',
        phone: '+91 9876543228',
        altPhone: '+91 9876543229',
        email: 'vikram.desai@medorica.com',
        photoUrl: null,
        headquarter: 'Bangalore',
        territories: ['Karnataka', 'Telangana'],
        teamId: '3',
      ),
      TeamMember(
        id: '11',
        name: 'Anjali Nair',
        phone: '+91 9876543230',
        altPhone: '+91 9876543231',
        email: 'anjali.nair@medorica.com',
        photoUrl: null,
        headquarter: 'Bangalore',
        territories: ['Kerala', 'Tamil Nadu'],
        teamId: '3',
      ),
      TeamMember(
        id: '12',
        name: 'Deepak Kumar',
        phone: '+91 9876543232',
        altPhone: '+91 9876543233',
        email: 'deepak.kumar@medorica.com',
        photoUrl: null,
        headquarter: 'Bangalore',
        territories: ['Telangana', 'Andhra Pradesh'],
        teamId: '3',
      ),
    ];
    state = state.copyWith(members: mockMembers);
  }

  /// Get members by team ID
  void setMembersByTeamId(String teamId) {
    final teamMembers = state.members.where((m) => m.teamId == teamId).toList();
    state = state.copyWith(members: teamMembers);
  }

  /// Select a member
  void selectMember(TeamMember member) {
    state = state.copyWith(selectedMember: member);
  }

  /// Add team member
  void addMember(TeamMember member) {
    final currentMembers = [...state.members, member];
    state = state.copyWith(members: currentMembers);
  }

  /// Update member
  void updateMember(TeamMember member) {
    final updatedMembers = state.members.map((m) => m.id == member.id ? member : m).toList();
    state = state.copyWith(members: updatedMembers);
  }

  /// Delete member
  void deleteMember(String memberId) {
    final filteredMembers = state.members.where((m) => m.id != memberId).toList();
    state = state.copyWith(members: filteredMembers);
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
