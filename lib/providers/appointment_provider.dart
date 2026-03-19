import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/appointment.dart';
import '../notifiers/appointment_notifier.dart';
import '../services/appointment/appointment_services.dart';
import 'auth_provider.dart';

final appointmentServicesProvider = Provider<AppointmentServices>((ref) {
  return AppointmentServices();
});

final appointmentNotifierProvider =
    StateNotifierProvider<AppointmentNotifier, AsyncValue<List<Appointment>>>((ref) {
      final notifier = AppointmentNotifier(
        ref.read(appointmentServicesProvider),
      );

      ref.listen(authNotifierProvider, (previous, next) {
        if (!next.isAuthenticated || next.asmId == null) {
          notifier.syncAsm(null);
          return;
        }
        notifier.syncAsm(next.asmId);
      }, fireImmediately: true);

      return notifier;
    });

final appointmentProvider = Provider<AsyncValue<List<Appointment>>>((ref) {
  return ref.watch(appointmentNotifierProvider);
});

// Provider for a single appointment by ID
final appointmentDetailProvider = Provider.autoDispose.family<
  Appointment?,
  String
>((ref, id) {
  final appointmentsAsync = ref.watch(appointmentProvider);
  return appointmentsAsync.maybeWhen(
    data: (appointments) {
      try {
        return appointments.firstWhere((appointment) => appointment.id == id);
      } catch (e) {
        return null;
      }
    },
    orElse: () => null,
  );
});

// Provider for appointments by doctor ID
final appointmentsByDoctorProvider = Provider.family<List<Appointment>, String>(
  (ref, doctorId) {
    final appointmentsAsync = ref.watch(appointmentProvider);
    return appointmentsAsync.maybeWhen(
      data: (appointments) => appointments
          .where((appointment) => appointment.doctorId == doctorId)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date)),
      orElse: () => [],
    );
  },
);

// Provider for upcoming appointments
final upcomingAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final appointmentsAsync = ref.watch(appointmentProvider);
  final now = DateTime.now();
  return appointmentsAsync.maybeWhen(
    data: (appointments) => appointments
        .where(
          (appointment) =>
              appointment.date.isAfter(now) &&
              (appointment.status == AppointmentStatus.pending ||
                  appointment.status == AppointmentStatus.ongoing),
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date)),
    orElse: () => [],
  );
});

// Provider for past appointments
final pastAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final appointmentsAsync = ref.watch(appointmentProvider);
  final now = DateTime.now();
  return appointmentsAsync.maybeWhen(
    data: (appointments) => appointments
        .where((appointment) => appointment.date.isBefore(now))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)),
    orElse: () => [],
  );
});

// Provider for filtered appointments by date
final appointmentsByDateProvider = Provider.family<List<Appointment>, DateTime>(
  (ref, date) {
    final appointmentsAsync = ref.watch(appointmentProvider);
    return appointmentsAsync.maybeWhen(
      data: (appointments) => appointments
          .where(
            (appointment) =>
                appointment.date.year == date.year &&
                appointment.date.month == date.month &&
                appointment.date.day == date.day,
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date)),
      orElse: () => [],
    );
  },
);

// Provider for filtered appointments by status
final appointmentsByStatusProvider =
    Provider.family<List<Appointment>, AppointmentStatus>((ref, status) {
      final appointmentsAsync = ref.watch(appointmentProvider);
      return appointmentsAsync.maybeWhen(
        data: (appointments) => appointments
            .where((appointment) => appointment.status == status)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)),
        orElse: () => [],
      );
    });
