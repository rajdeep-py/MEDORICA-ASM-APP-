import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../cards/home/attendance_card.dart';
import '../../cards/home/greeting_card.dart';
import '../../cards/home/home_footer.dart';
import '../../cards/home/monthly_target_card.dart';
import '../../cards/home/month_plan_card.dart';
import '../../cards/home/quick_actions_card.dart';
import '../../cards/home/quit_app_bottomsheet.dart';
import 'package:flutter/services.dart';
import '../../widgets/ads_carousels.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const QuitAppBottomSheet(),
        );
        if (shouldExit == true) {
          SystemNavigator.pop();
          return false;
        }
        return false;
      },
      child: Scaffold(
        appBar: MRAppBar(showBack: false),
        backgroundColor: AppColors.surface,
        bottomNavigationBar: const MRBottomNavBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingHorizontal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                const MRGreetingCard(),
                const SizedBox(height: AppSpacing.md),
                const MRAttendanceCard(),
                const SizedBox(height: AppSpacing.md),
                const MonthPlanCard(),
                const SizedBox(height: AppSpacing.md),
                const MonthlyTargetCard(),
                const SizedBox(height: AppSpacing.md),
                const MRQuickActionsCard(),
                const SizedBox(height: AppSpacing.md),
                const AdsCarousel(height: 500),
                const SizedBox(height: AppSpacing.xl),
                const HomeFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}