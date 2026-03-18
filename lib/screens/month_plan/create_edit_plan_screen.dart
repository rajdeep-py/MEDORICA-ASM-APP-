import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/team_provider.dart';
import '../../providers/month_plan_provider.dart';
import '../../models/month_plan.dart';
import '../../models/team.dart';

class CreateEditPlanScreen extends ConsumerStatefulWidget {
  final MonthPlanEntry? initialEntry;
  const CreateEditPlanScreen({super.key, this.initialEntry});

  @override
  ConsumerState<CreateEditPlanScreen> createState() =>
      _CreateEditPlanScreenState();
}

class _CreateEditPlanScreenState extends ConsumerState<CreateEditPlanScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedMemberId;
  final List<PlanStep> _steps = [];
  final _titleCtr = TextEditingController();
  final _descCtr = TextEditingController();
  final _timeCtr = TextEditingController();

  bool get isEditing => widget.initialEntry != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final e = widget.initialEntry!;
      _selectedDate = e.date;
      _selectedMemberId = e.memberId;
      _steps.addAll(e.steps);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(allTeamsProvider);
    final isTeamsLoading = ref.watch(isTeamsLoadingProvider);
    final teamsError = ref.watch(teamErrorProvider);
    final members = _memberOptionsFromTeams(teams);
    final isSubmitting = ref.watch(isMonthPlanSubmittingProvider);
    return Scaffold(
      appBar: const MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Create Plan',
        subtitleText: 'Schedule a day plan',
      ),
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: AppCardStyles.styleCard(
                  backgroundColor: AppColors.white,
                  borderRadius: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                    Text(
                      '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Assign To'),
              hint: Text(
                isTeamsLoading
                    ? 'Loading team members...'
                    : members.isEmpty
                    ? 'No team members available'
                    : 'Choose a member',
              ),
              items: members
                  .map(
                    (m) => DropdownMenuItem(
                      value: m.mrId,
                      child: Text('${m.name} (${m.teamName})'),
                    ),
                  )
                  .toList(),
              initialValue: members.any((m) => m.mrId == _selectedMemberId)
                  ? _selectedMemberId
                  : null,
              onChanged: (v) => setState(() => _selectedMemberId = v),
            ),
            if (teamsError != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  teamsError,
                  style: AppTypography.caption.copyWith(color: AppColors.error),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            Text('Add steps for the day', style: AppTypography.tagline),
            const SizedBox(height: AppSpacing.sm),
            _buildStepForm(),
            const SizedBox(height: AppSpacing.md),
            ..._steps.map(
              (s) => ListTile(
                title: Text(s.title),
                subtitle: Text('${s.time} • ${s.description}'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: isSubmitting ? null : _savePlan,
              style: AppButtonStyles.primaryButton(backgroundColor: AppColors.primary, foregroundColor: AppColors.secondary),
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      'Save Plan',
                      style: AppTypography.buttonLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepForm() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppCardStyles.inputFieldCard(),
      child: Column(
        children: [
          TextFormField(
            controller: _timeCtr,
            readOnly: true,
            onTap: _pickStepTime,
            decoration: const InputDecoration(
              labelText: 'Time',
              hintText: 'Tap to select from clock',
              suffixIcon: Icon(Icons.access_time),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _titleCtr,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _descCtr,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _addStep,
                  child: const Text('Add Step'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addStep() {
    final t = _timeCtr.text.trim();
    final title = _titleCtr.text.trim();
    final d = _descCtr.text.trim();
    if (t.isEmpty || title.isEmpty) return;
    setState(() {
      _steps.add(PlanStep(time: t, title: title, description: d));
      _timeCtr.clear();
      _titleCtr.clear();
      _descCtr.clear();
    });
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickStepTime() async {
    final initial = _timeCtr.text.trim().isNotEmpty
        ? _parseTimeOfDay(_timeCtr.text.trim())
        : TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );

    if (picked == null) {
      return;
    }

    final formatted = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(picked, alwaysUse24HourFormat: false);

    setState(() {
      _timeCtr.text = formatted;
    });
  }

  TimeOfDay? _parseTimeOfDay(String raw) {
    final value = raw.toUpperCase();
    final expression = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$');
    final match = expression.firstMatch(value);
    if (match == null) {
      return null;
    }

    final hourRaw = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    final period = match.group(3);
    if (hourRaw == null || minute == null || period == null) {
      return null;
    }

    if (hourRaw < 1 || hourRaw > 12 || minute < 0 || minute > 59) {
      return null;
    }

    var hour = hourRaw % 12;
    if (period == 'PM') {
      hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _savePlan() async {
    final selectedMemberId = _selectedMemberId;
    if (selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a team member')),
      );
      return;
    }
    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one activity step')),
      );
      return;
    }

    final notifier = ref.read(monthPlanNotifierProvider.notifier);
    if (isEditing) {
      final existing = widget.initialEntry!;
      final updated = existing.copyWith(
        date: _selectedDate,
        memberId: selectedMemberId,
        steps: List.from(_steps),
      );
      // Prepare payload for update
      final payload = {
        'status': existing.status,
        'member_day_plans': [
          {
            'mr_id': updated.memberId,
            'mr_name': existing.memberName,
            'activities': updated.steps.map((s) => s.toActivityJson()).toList(),
          }
        ],
      };
      try {
        await notifier.updatePlanById(existing.planId?.toString() ?? '', payload);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan updated successfully')));
          context.pop();
        }
      } catch (error) {
        if (mounted) {
          final message = error.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } else {
      final members = _memberOptionsFromTeams(ref.read(allTeamsProvider));
      _PlanMemberOption? selectedMember;
      for (final member in members) {
        if (member.mrId == selectedMemberId) {
          selectedMember = member;
          break;
        }
      }

      if (selectedMember == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selected member not found')),
          );
        }
        return;
      }

      try {
        await notifier.createPlanForMember(
          memberId: selectedMember.mrId,
          memberName: selectedMember.name,
          teamId: selectedMember.teamId,
          date: _selectedDate,
          steps: List.from(_steps),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plan created successfully')),
          );
          context.pop();
        }
      } catch (error) {
        if (mounted) {
          final message = error.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    }
  }

  List<_PlanMemberOption> _memberOptionsFromTeams(List<Team> teams) {
    final options = <_PlanMemberOption>[];
    for (final team in teams) {
      final teamId = (team.numericTeamId ?? int.tryParse(team.id) ?? 0)
          .toString();
      for (final member in team.teamMembers) {
        if (member.mrId.trim().isEmpty) {
          continue;
        }
        options.add(
          _PlanMemberOption(
            mrId: member.mrId.trim(),
            name: member.fullName.trim().isEmpty
                ? member.mrId.trim()
                : member.fullName.trim(),
            teamId: teamId,
            teamName: team.name.trim().isEmpty ? 'Team $teamId' : team.name,
          ),
        );
      }
    }
    return options;
  }
}

class _PlanMemberOption {
  final String mrId;
  final String name;
  final String teamId;
  final String teamName;

  const _PlanMemberOption({
    required this.mrId,
    required this.name,
    required this.teamId,
    required this.teamName,
  });
}
