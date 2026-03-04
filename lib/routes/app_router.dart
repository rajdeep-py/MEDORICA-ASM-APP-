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
import '../screens/distributor/distributor_screen.dart';
import '../screens/distributor/distributor_detail_screen.dart';
import '../screens/distributor/add_edit_distributor_screen.dart';
import '../screens/chemist_shop/chemist_shop_screen.dart';
import '../screens/chemist_shop/chemist_shop_detail_screen.dart';
import '../screens/chemist_shop/add_edit_chemist_shop_screen.dart';
import '../screens/order/order_screen.dart';
import '../screens/order/create_new_order_screen.dart';
import '../screens/about_us/about_us_screen.dart';
import '../screens/doctor/doctor_screen.dart';
import '../screens/doctor/doctor_detail_screen.dart';
import '../screens/doctor/add_edit_doctor_screen.dart';
import '../screens/appointment/my_appointment_screen.dart';
import '../screens/appointment/schedule_edit_appointment_screen.dart';
import '../models/team_member.dart';
import '../models/distributor.dart';
import '../models/chemist_shop.dart' hide Doctor;
import '../models/doctor.dart';

class AppRouter {
  // Route paths
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String myTeam = '/my-team';
  static const String teamMembers = '/team-members/:teamId';
  static const String teamMemberDetail = '/team-member-detail/:memberId';
  static const String distributors = '/distributors';
  static const String distributorDetail = '/distributor-detail/:distributorId';
  static const String addEditDistributor = '/add-edit-distributor';
  static const String chemistShops = '/chemist-shops';
  static const String chemistShopDetail = '/chemist-shop-detail/:shopId';
  static const String addEditChemistShop = '/add-edit-chemist-shop';
  static const String orders = '/mr-orders';
  static const String createOrder = '/create-order';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String aboutUs = '/about-us';
  static const String doctors = '/asm/doctor';
  static const String addDoctor = '/asm/doctor/add';
  static const String editDoctor = '/asm/doctor/edit/:doctorId';
  static const String doctorDetail = '/asm/doctor/:doctorId';
  static const String appointments = '/asm/appointments';
  static const String scheduleAppointment = '/asm/appointments/schedule';
  static const String editAppointment = '/asm/appointments/edit/:appointmentId';

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
          path: AppRouter.distributors,
          builder: (context, state) => const DistributorScreen(),
        ),
        GoRoute(
          path: AppRouter.distributorDetail,
          builder: (context, state) {
            final distributor = state.extra as Distributor?;
            return distributor != null
                ? DistributorDetailScreen(distributor: distributor)
                : const Scaffold(
                    body: Center(child: Text('Distributor not found')));
          },
        ),
        GoRoute(
          path: AppRouter.addEditDistributor,
          builder: (context, state) {
            final distributor = state.extra as Distributor?;
            return AddEditDistributorScreen(distributor: distributor);
          },
        ),
        GoRoute(
          path: '/add-edit-distributor/:distributorId',
          builder: (context, state) {
            final distributor = state.extra as Distributor?;
            return AddEditDistributorScreen(distributor: distributor);
          },
        ),
        GoRoute(
          path: AppRouter.chemistShops,
          builder: (context, state) => const ChemistShopScreen(),
        ),
        GoRoute(
          path: AppRouter.chemistShopDetail,
          builder: (context, state) {
            final shop = state.extra as ChemistShop?;
            return shop != null
                ? ChemistShopDetailScreen(shop: shop)
                : const Scaffold(
                    body: Center(child: Text('Shop not found')));
          },
        ),
        GoRoute(
          path: AppRouter.addEditChemistShop,
          builder: (context, state) {
            final shop = state.extra as ChemistShop?;
            return AddEditChemistShopScreen(shop: shop);
          },
        ),
        GoRoute(
          path: '/add-edit-chemist-shop/:shopId',
          builder: (context, state) {
            final shop = state.extra as ChemistShop?;
            return AddEditChemistShopScreen(shop: shop);
          },
        ),
        GoRoute(
          path: AppRouter.orders,
          builder: (context, state) => const OrderScreen(),
        ),
        GoRoute(
          path: AppRouter.createOrder,
          builder: (context, state) => const CreateNewOrderScreen(),
        ),
        GoRoute(
          path: AppRouter.notifications,
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: AppRouter.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRouter.aboutUs,
          builder: (context, state) => const AboutUsScreen(),
        ),
        GoRoute(
          path: AppRouter.doctors,
          builder: (context, state) => const MyDoctorScreen(),
        ),
        GoRoute(
          path: AppRouter.addDoctor,
          builder: (context, state) => const AddEditDoctorScreen(),
        ),
        GoRoute(
          path: AppRouter.editDoctor,
          builder: (context, state) {
            final doctor = state.extra as Doctor?;
            return AddEditDoctorScreen(doctor: doctor);
          },
        ),
        GoRoute(
          path: AppRouter.doctorDetail,
          builder: (context, state) {
            final doctorId = state.pathParameters['doctorId'] ?? '';
            return DoctorDetailScreen(doctorId: doctorId);
          },
        ),
        GoRoute(
          path: AppRouter.appointments,
          builder: (context, state) => const MyAppointmentScreen(),
        ),
        GoRoute(
          path: AppRouter.scheduleAppointment,
          builder: (context, state) {
            final doctorId = state.uri.queryParameters['doctorId'];
            return ScheduleEditAppointmentScreen(initialDoctorId: doctorId);
          },
        ),
        GoRoute(
          path: AppRouter.editAppointment,
          builder: (context, state) {
            final appointmentId = state.pathParameters['appointmentId'];
            return ScheduleEditAppointmentScreen(appointmentId: appointmentId);
          },
        ),
      ],
    );
  }
}
