import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/app_theme.dart';
import '../../routes/app_router.dart';

class MRQuickActionsCard extends StatelessWidget {
  const MRQuickActionsCard({super.key});

  Widget _actionTile(
    BuildContext context,
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$label tapped')));
          },
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Center(
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Iconsax.user_octagon,
        label: 'Team',
        onTap: () => context.push(AppRouter.myTeam),
      ),
      (
        icon: Iconsax.shopping_cart,
        label: 'Orders',
        onTap: () => context.push(AppRouter.orders),
      ),
      (
        icon: Iconsax.gift5,
        label: 'Gifts',
        onTap: () => context.push(AppRouter.gifts),
      ),
      (
        icon: Iconsax.presention_chart,
        label: 'Visual Ads',
        onTap: () => context.push(AppRouter.visualAds),
      ),
      (
        icon: Iconsax.truck,
        label: 'Distributors',
        onTap: () => context.push(AppRouter.distributors),
      ),
      (
        icon: Iconsax.wallet,
        label: 'Salary Slip',
        onTap: () => context.push(AppRouter.profile),
      ),
      (
        icon: Iconsax.shop,
        label: 'Chemists',
        onTap: () => context.push(AppRouter.chemistShops),
      ),
      (
        icon: Iconsax.calendar,
        label: 'Attendance',
        onTap: () => context.push(AppRouter.myAttendance),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Quick Actions',
                  style: AppTypography.h3.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              children: items
                  .map(
                    (item) => _actionTile(
                      context,
                      item.icon,
                      item.label,
                      onTap: item.onTap,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
