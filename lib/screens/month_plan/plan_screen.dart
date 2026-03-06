import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/team_member_provider.dart';
import '../../providers/month_plan_provider.dart';
import '../../cards/month_plan/calendar_card.dart';
import '../../cards/month_plan/plan_card.dart';

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  String? _selectedMemberId;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(allTeamMembersProvider);
    final selectedId = _selectedMemberId ?? (members.isNotEmpty ? members.first.id : null);
    final plans = selectedId != null && _selectedDate != null
        ? ref.watch(monthPlanForMemberAndDateProvider({'memberId': selectedId, 'date': _selectedDate}))
        : [];

    return Scaffold(
      appBar: const MRAppBar(showBack: true, showActions: false, titleText: 'Monthly Plan', subtitleText: 'View plans by team member'),
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Team Member'),
              items: members.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))).toList(),
              initialValue: selectedId,
              onChanged: (v) => setState(() => _selectedMemberId = v),
            ),
            const SizedBox(height: AppSpacing.md),
            if (selectedId != null)
              CalendarCard(memberId: selectedId, onDateSelected: (d) => setState(() => _selectedDate = d)),
            const SizedBox(height: AppSpacing.md),
            if (_selectedDate == null)
              Text('Tap a date on the calendar to view its plan', style: AppTypography.description)
            else if (plans.isEmpty)
              Text('No plans for selected date', style: AppTypography.description)
            else
              Expanded(
                child: ListView(
                  children: plans.map((e) => PlanCard(entry: e)).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
