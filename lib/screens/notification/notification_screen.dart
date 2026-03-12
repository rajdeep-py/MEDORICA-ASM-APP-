import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/notification/notification_card.dart';
import '../../providers/notification_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final hasInitialLoading =
        notificationState.isLoading && notifications.isEmpty;
    final hasBlockingError =
        notificationState.error != null && notifications.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Notifications',
        subtitleText: hasInitialLoading
            ? 'Fetching latest updates'
            : unreadCount > 0
            ? 'You have $unreadCount unread'
            : 'All caught up',
        onBack: () => context.pop(),
      ),
      body: hasInitialLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : hasBlockingError
          ? _NotificationErrorState(
              message: notificationState.error!,
              onRetry: () {
                ref
                    .read(notificationProvider.notifier)
                    .loadNotifications(forceRefresh: true);
              },
            )
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () {
                return ref
                    .read(notificationProvider.notifier)
                    .loadNotifications(forceRefresh: true);
              },
              child: notifications.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 160),
                        _NotificationEmptyState(),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      itemCount:
                          notifications.length +
                          (notificationState.error != null ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (notificationState.error != null && index == 0) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.md,
                              AppSpacing.md,
                              AppSpacing.md,
                              0,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.error.withAlpha(18),
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.md,
                                ),
                                border: Border.all(
                                  color: AppColors.error.withAlpha(60),
                                ),
                              ),
                              child: Text(
                                notificationState.error!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          );
                        }

                        final notificationIndex =
                            notificationState.error != null ? index - 1 : index;
                        final notification = notifications[notificationIndex];
                        return NotificationCard(
                          notification: notification,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(notification.title),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          onDelete: () {
                            ref
                                .read(notificationProvider.notifier)
                                .deleteNotification(notification.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notification deleted'),
                                backgroundColor: AppColors.secondary,
                              ),
                            );
                          },
                          onMarkAsRead: (id) {
                            ref
                                .read(notificationProvider.notifier)
                                .markAsRead(id);
                          },
                        );
                      },
                    ),
            ),
      floatingActionButton: unreadCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                ref.read(notificationProvider.notifier).markAllAsRead();
              },
              icon: const Icon(Iconsax.tick_circle),
              label: const Text('Mark All as Read'),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }
}

class _NotificationEmptyState extends StatelessWidget {
  const _NotificationEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.notification,
            size: 80,
            color: AppColors.quaternary.withAlpha(76),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No Notifications',
            style: AppTypography.h3.copyWith(color: AppColors.quaternary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You\'re all caught up!',
            style: AppTypography.body.copyWith(color: AppColors.quaternary),
          ),
        ],
      ),
    );
  }
}

class _NotificationErrorState extends StatelessWidget {
  const _NotificationErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.warning_2, size: 56, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unable to load notifications',
              style: AppTypography.h3.copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.body.copyWith(color: AppColors.quaternary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Iconsax.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
