import 'package:flutter/material.dart';

import '../../models/gift.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class GiftCard extends StatelessWidget {
  final GiftApplication application;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const GiftCard({
    super.key,
    required this.application,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: AppCardStyles.styleCard(
        backgroundColor: AppColors.white,
        borderRadius: AppBorderRadius.lg,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gift Icon
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Iconsax.gift,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            // Main Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${application.requestId}',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          application.status,
                          style: AppTypography.caption.copyWith(
                            color: application.status == 'approved'
                                ? AppColors.success
                                : application.status == 'rejected'
                                ? AppColors.error
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(application.giftName ?? '', style: AppTypography.body),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.user,
                        size: 16,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          application.doctorName ?? application.doctorId,
                          style: AppTypography.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Iconsax.calendar,
                        size: 16,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        application.giftDate
                                ?.toLocal()
                                .toString()
                                .split(' ')
                                .first ??
                            '-',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.cake,
                        size: 16,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          application.occassion ?? '-',
                          style: AppTypography.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if ((application.remarks ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.message,
                          size: 16,
                          color: AppColors.quaternary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            application.remarks ?? '-',
                            style: AppTypography.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Edit/Delete
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Iconsax.edit,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: const Icon(
                    Iconsax.trash,
                    size: 20,
                    color: AppColors.error,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
