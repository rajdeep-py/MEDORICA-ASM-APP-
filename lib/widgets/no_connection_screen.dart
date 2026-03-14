import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_theme.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({
    super.key,
    required this.onRetry,
    this.isRetrying = false,
  });

  final VoidCallback onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                  ),
                  child: const Icon(
                    Iconsax.wifi_square,
                    color: AppColors.primary,
                    size: 38,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'No Internet Connection',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.primary,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Please check your network and try again.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.quaternary,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: 180,
                  child: ElevatedButton.icon(
                    onPressed: isRetrying ? null : onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      ),
                    ),
                    icon: isRetrying
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Icon(Iconsax.refresh, size: 18),
                    label: Text(
                      isRetrying ? 'Checking...' : 'Retry',
                      style: AppTypography.buttonMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
