import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/team_member_provider.dart';
import '../../providers/month_plan_provider.dart';
import '../../models/month_plan.dart';

class CreateEditPlanScreen extends ConsumerStatefulWidget {
  final MonthPlanEntry? initialEntry;
  const CreateEditPlanScreen({super.key, this.initialEntry});

  @override
  ConsumerState<CreateEditPlanScreen> createState() => _CreateEditPlanScreenState();
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
    final members = ref.watch(allTeamMembersProvider);
    return Scaffold(
      appBar: const MRAppBar(showBack: true, showActions: false, titleText: 'Create Plan', subtitleText: 'Schedule a day plan'),
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
                decoration: AppCardStyles.styleCard(backgroundColor: AppColors.white, borderRadius: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary)),
                    Text('${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}', style: AppTypography.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Assign To'),
              items: members.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))).toList(),
              initialValue: _selectedMemberId,
              onChanged: (v) => setState(() => _selectedMemberId = v),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Add steps for the day', style: AppTypography.tagline),
            const SizedBox(height: AppSpacing.sm),
            _buildStepForm(),
            const SizedBox(height: AppSpacing.md),
            ..._steps.map((s) => ListTile(title: Text(s.title), subtitle: Text('${s.time} • ${s.description}'))),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: _savePlan,
              style: AppButtonStyles.primaryButton(),
              child: Text('Save Plan', style: AppTypography.buttonLarge.copyWith(color: AppColors.white)),
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
          TextFormField(controller: _timeCtr, decoration: const InputDecoration(labelText: 'Time (e.g. 10:00 AM)')),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(controller: _titleCtr, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(controller: _descCtr, decoration: const InputDecoration(labelText: 'Description')),
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
    final d = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 365 * 2)));
    if (d != null) setState(() => _selectedDate = d);
  }

  void _savePlan() {
    if (_selectedMemberId == null) return;
    if (_steps.isEmpty) return;
    final notifier = ref.read(monthPlanNotifierProvider.notifier);
    if (isEditing) {
      final existing = widget.initialEntry!;
      final updated = existing.copyWith(date: _selectedDate, memberId: _selectedMemberId, steps: List.from(_steps));
      notifier.updateEntry(updated);
    } else {
      notifier.createPlanForMember(_selectedMemberId!, _selectedDate, _steps);
    }
    context.pop();
  }
}
