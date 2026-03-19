import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../cards/appointment/appointment_card.dart';
import '../../cards/appointment/appointment_filter_options_card.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';

class MyAppointmentScreen extends ConsumerStatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  ConsumerState<MyAppointmentScreen> createState() =>
      _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends ConsumerState<MyAppointmentScreen> {
  DateTime? _selectedDate;
  AppointmentStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(appointmentProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go(AppRouter.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: MRAppBar(
          showBack: false,
          showActions: false,
          titleText: 'My DCR',
          subtitleText: 'View and Manage Doctor Call Reports',
        ),
        body: Column(
          children: [
            // Filter Options Card
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppointmentFilterOptionsCard(
                selectedDate: _selectedDate,
                selectedStatus: _selectedStatus,
                onDateFilterChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                onStatusFilterChanged: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),
            ),

            // Appointments List
            Expanded(
              child: appointmentsAsync.when(
                data: (appointments) {
                  final filteredAppointments = _filterAppointments(appointments);
                  return filteredAppointments.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          itemCount: filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = filteredAppointments[index];
                            return AppointmentCard(appointment: appointment);
                          },
                        );
                },
                loading: () => const Center(
                  child: Loader(
                    text: 'Loading appointments...',
                    logoSize: 36.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                error: (err, _) => Center(
                  child: Text('Error loading appointments'),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () => context.push('/asm/appointments/schedule'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(180),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Iconsax.add_square,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'New Appointment',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 6),
      ),
    );
  }

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    var filtered = List<Appointment>.from(appointments);

    // Filter by date
    if (_selectedDate != null) {
      filtered = filtered
          .where(
            (appointment) =>
                appointment.date.year == _selectedDate!.year &&
                appointment.date.month == _selectedDate!.month &&
                appointment.date.day == _selectedDate!.day,
          )
          .toList();
    }

    // Filter by status
    if (_selectedStatus != null) {
      filtered = filtered
          .where((appointment) => appointment.status == _selectedStatus)
          .toList();
    }

    // Sort by date (upcoming first, then past)
    filtered.sort((a, b) {
      final now = DateTime.now();
      final aFuture = a.date.isAfter(now);
      final bFuture = b.date.isAfter(now);

      if (aFuture && !bFuture) return -1;
      if (!aFuture && bFuture) return 1;
      if (aFuture && bFuture) return a.date.compareTo(b.date);
      return b.date.compareTo(a.date);
    });

    return filtered;
  }

  Widget _buildEmptyState() {
    final hasActiveFilters = _selectedDate != null || _selectedStatus != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveFilters ? Iconsax.search_status : Iconsax.calendar_1,
              size: 80,
              color: AppColors.quaternary.withAlpha(127),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasActiveFilters
                  ? 'No appointments found'
                  : 'No appointments yet',
              style: AppTypography.h3.copyWith(color: AppColors.quaternary),
            ),
            
          ],
        ),
      ),
    );
  }
}
