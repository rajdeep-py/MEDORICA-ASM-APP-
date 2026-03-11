import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/doctor.dart';
import '../notifiers/doctor_notifier.dart';
import '../services/doctor_network/doctor_network_services.dart';
import 'auth_provider.dart';

final doctorNetworkServicesProvider = Provider<DoctorNetworkServices>((ref) {
  return DoctorNetworkServices();
});

final doctorNotifierProvider =
    StateNotifierProvider<DoctorNotifier, DoctorState>((ref) {
      final notifier = DoctorNotifier(ref.read(doctorNetworkServicesProvider));

      ref.listen(authNotifierProvider, (previous, next) {
        if (!next.isAuthenticated || next.asmId == null) {
          notifier.syncAsm(null);
          return;
        }
        notifier.syncAsm(next.asmId);
      }, fireImmediately: true);

      return notifier;
    });

// Provider for the list of doctors
final doctorProvider = Provider<List<Doctor>>((ref) {
  return ref.watch(doctorNotifierProvider).doctors;
});

final isDoctorsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(doctorNotifierProvider).isLoading;
});

final doctorErrorProvider = Provider<String?>((ref) {
  return ref.watch(doctorNotifierProvider).error;
});

// Provider for a single doctor by ID
final doctorDetailProvider = Provider.family<Doctor?, String>((ref, id) {
  final doctors = ref.watch(doctorProvider);
  try {
    return doctors.firstWhere((doctor) => doctor.id == id);
  } catch (e) {
    return null;
  }
});

final doctorDetailRemoteProvider = FutureProvider.family<Doctor?, String>((
  ref,
  doctorId,
) async {
  final localDoctor = ref.read(doctorDetailProvider(doctorId));
  if (localDoctor != null) {
    return localDoctor;
  }

  final asmId = ref.read(authNotifierProvider).asmId;
  if (asmId == null || asmId.trim().isEmpty) {
    return null;
  }

  return ref
      .read(doctorNetworkServicesProvider)
      .fetchDoctorByAsmAndDoctorId(asmId: asmId, doctorId: doctorId);
});

// Provider for searched doctors
final searchDoctorProvider = Provider.family<List<Doctor>, String>((
  ref,
  query,
) {
  final doctors = ref.watch(doctorProvider);
  if (query.isEmpty) return doctors;
  final lowerQuery = query.toLowerCase();
  return doctors
      .where(
        (doctor) =>
            doctor.name.toLowerCase().contains(lowerQuery) ||
            doctor.specialization.toLowerCase().contains(lowerQuery),
      )
      .toList();
});

// Provider for filtered doctors by specialization
final filteredDoctorProvider = Provider.family<List<Doctor>, String>((
  ref,
  specialization,
) {
  final doctors = ref.watch(doctorProvider);
  if (specialization.isEmpty) return doctors;
  return doctors
      .where((doctor) => doctor.specialization == specialization)
      .toList();
});

// Provider for all specializations
final specializationsProvider = Provider<List<String>>((ref) {
  final doctors = ref.watch(doctorProvider);
  return doctors.map((doctor) => doctor.specialization).toSet().toList();
});
