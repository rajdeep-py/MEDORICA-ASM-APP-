import 'package:flutter_riverpod/legacy.dart';

import '../models/month_plan.dart';
import '../services/month_plan/month_plan_services.dart';

class MonthPlanState {
  final bool isLoading;
  final bool isSubmitting;
  final List<MonthPlanEntry> entries;
  final String? selectedMemberId;
  final DateTime? selectedDate;
  final String? error;

  MonthPlanState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.entries = const [],
    this.selectedMemberId,
    this.selectedDate,
    this.error,
  });

  MonthPlanState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<MonthPlanEntry>? entries,
    String? selectedMemberId,
    DateTime? selectedDate,
    String? error,
  }) {
    return MonthPlanState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      entries: entries ?? this.entries,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      selectedDate: selectedDate ?? this.selectedDate,
      error: error,
    );
  }
}

class MonthPlanNotifier extends StateNotifier<MonthPlanState> {
  MonthPlanNotifier(this._services) : super(MonthPlanState());

  final MonthPlanServices _services;
  String? _activeAsmId;

  Future<void> syncAsm(String? asmId) async {
    final nextAsmId = asmId?.trim();
    if (nextAsmId == null || nextAsmId.isEmpty) {
      _activeAsmId = null;
      state = MonthPlanState();
      return;
    }

    _activeAsmId = nextAsmId;
  }

  void setLoading(bool loading) =>
      state = state.copyWith(isLoading: loading, error: null);

  Future<void> setSelectedMember(String? memberId) async {
    state = state.copyWith(selectedMemberId: memberId, selectedDate: null);

    final normalized = memberId?.trim();
    if (normalized == null || normalized.isEmpty) {
      state = state.copyWith(entries: const [], isLoading: false, error: null);
      return;
    }

    await loadPlansByMember(normalized, forceRefresh: true);
  }

  void setSelectedDate(DateTime date) =>
      state = state.copyWith(selectedDate: date, error: null);

  Future<void> loadPlansByMember(
    String memberId, {
    bool forceRefresh = false,
  }) async {
    final normalized = memberId.trim();
    if (normalized.isEmpty) {
      state = state.copyWith(entries: const [], isLoading: false, error: null);
      return;
    }

    if (!forceRefresh &&
        state.selectedMemberId == normalized &&
        state.entries.isNotEmpty) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      selectedMemberId: normalized,
      error: null,
    );

    try {
      final entries = await _services.fetchMonthlyPlansByMrId(normalized);
      state = state.copyWith(isLoading: false, entries: entries, error: null);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        entries: const [],
        error: _readErrorMessage(error),
      );
    }
  }

  void addEntry(MonthPlanEntry entry) {
    final updated = [...state.entries, entry];
    updated.sort((a, b) => b.date.compareTo(a.date));
    state = state.copyWith(entries: updated, error: null);
  }

  void updateEntry(MonthPlanEntry entry) {
    final updated = state.entries
        .map((e) => e.id == entry.id ? entry : e)
        .toList();
    state = state.copyWith(entries: updated, error: null);
  }

  void removeEntry(String id) {
    final updated = state.entries.where((e) => e.id != id).toList();
    state = state.copyWith(entries: updated, error: null);
  }

  Future<void> deletePlanById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final planId = int.tryParse(id);
      if (planId == null) {
        throw Exception('Invalid plan id.');
      }
      await _services.deleteMonthlyPlan(planId);
      removeEntry(id);
      state = state.copyWith(isLoading: false, error: null);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  Future<void> updatePlanById(String id, Map<String, dynamic> payload) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final planId = int.tryParse(id);
      if (planId == null) {
        throw Exception('Invalid plan id.');
      }
      final updated = await _services.updateMonthlyPlan(planId, payload);
      updateEntry(updated);
      state = state.copyWith(isSubmitting: false, error: null);
    } catch (error) {
      state = state.copyWith(isSubmitting: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  List<MonthPlanEntry> entriesForMember(String memberId) {
    return state.entries.where((e) => e.memberId == memberId).toList();
  }

  List<MonthPlanEntry> entriesForMemberAndMonth(
    String memberId,
    int year,
    int month,
  ) {
    return state.entries
        .where(
          (e) =>
              e.memberId == memberId &&
              e.date.year == year &&
              e.date.month == month,
        )
        .toList();
  }

  List<MonthPlanEntry> entriesForMemberAndDate(String memberId, DateTime date) {
    return state.entries
        .where(
          (e) =>
              e.memberId == memberId &&
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();
  }

  Future<void> createPlanForMember({
    required String memberId,
    required String memberName,
    required String teamId,
    required DateTime date,
    required List<PlanStep> steps,
    String status = 'draft',
  }) async {
    if (_activeAsmId == null || _activeAsmId!.isEmpty) {
      throw Exception('ASM not found in current session. Please log in again.');
    }

    final parsedTeamId = int.tryParse(teamId.trim());
    if (parsedTeamId == null) {
      throw Exception('Invalid team id for selected member.');
    }

    state = state.copyWith(isSubmitting: true, error: null);

    final payload = MonthlyPlanCreatePayload(
      asmId: _activeAsmId!,
      teamId: parsedTeamId,
      mrId: memberId,
      planDate: date,
      status: status,
      activities: steps,
    );

    try {
      final created = await _services.createMonthlyPlan(payload);
      addEntry(created);
      state = state.copyWith(isSubmitting: false, error: null);
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        error: _readErrorMessage(error),
      );
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
