import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/team/my_team_screen.dart';
import '../screens/team/team_members_screen.dart';
import '../screens/team/team_member_detail_screen.dart';
import '../models/team_member.dart';

class AppRouter {
  // Route paths
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String myTeam = '/my-team';
  static const String teamMembers = '/team-members/:teamId';
  static const String teamMemberDetail = '/team-member-detail/:memberId';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: AppRouter.splash,
      routes: [
        GoRoute(
          path: AppRouter.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRouter.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRouter.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRouter.myTeam,
          builder: (context, state) => const MyTeamScreen(),
        ),
        GoRoute(
          path: AppRouter.teamMembers,
          builder: (context, state) {
            final teamId = state.pathParameters['teamId'] ?? '';
            final teamName = state.extra as String? ?? '';
            return TeamMembersScreen(teamId: teamId, teamName: teamName);
          },
        ),
        GoRoute(
          path: AppRouter.teamMemberDetail,
          builder: (context, state) {
            final member = state.extra as TeamMember?;
            return member != null
                ? TeamMemberDetailScreen(member: member)
                : const Scaffold(body: Center(child: Text('Member not found')));
          },
        ),
        GoRoute(
          path: AppRouter.notifications,
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: AppRouter.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}
