import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/month_plan.dart';
import '../../providers/month_plan_provider.dart';

class PlanCard extends ConsumerWidget {
  final MonthPlanEntry entry;
  const PlanCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppCardStyles.styleCard(backgroundColor: AppColors.white, borderRadius: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${entry.date.day}-${entry.date.month}-${entry.date.year}', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                    onPressed: () {
                      context.push('/month-plans/create', extra: entry);
                    },
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete plan'),
                          content: const Text('Are you sure you want to delete this plan?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (ok == true) {
                        ref.read(monthPlanNotifierProvider.notifier).removeEntry(entry.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...entry.steps.map((s) => _stepTile(s)).toList(),
        ],
      ),
    );
  }

  Widget _stepTile(PlanStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppBorderRadius.md)),
      child: Row(
        children: [
          SizedBox(width: 72, child: Text(step.time, style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary))),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text(step.description, style: AppTypography.caption.copyWith(color: AppColors.quaternary)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
