import 'package:asm_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/gift_provider.dart';
import '../../providers/doctor_provider.dart';

import '../../cards/gift/gift_filter_card.dart';
import '../../cards/gift/gift_card.dart';
import '../../routes/app_router.dart';

class GiftScreen extends ConsumerStatefulWidget {
  const GiftScreen({super.key});

  @override
  ConsumerState<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends ConsumerState<GiftScreen> {
  String? _selectedDoctorId;
  String? _selectedStatus = '';

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isGiftLoadingProvider);
    final error = ref.watch(giftErrorProvider);
    final applications = ref.watch(giftApplicationsProvider);
    final doctors = ref.watch(doctorProvider);
    final notifier = ref.read(giftNotifierProvider.notifier);

    // Filter applications
    final filteredApps = applications.where((app) {
      final doctorMatch =
          _selectedDoctorId == null ||
          _selectedDoctorId!.isEmpty ||
          app.doctorId == _selectedDoctorId;
      final statusMatch =
          (_selectedStatus == null || _selectedStatus!.isEmpty) ||
          app.status == _selectedStatus;
      return doctorMatch && statusMatch;
    }).toList();

    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        titleText: 'Gift Requests',
        subtitleText: 'Manage and request gifts for doctors',
        showActions: false,
      ),
      body: Column(
        children: [
          GiftFilterCard(
            doctors: doctors,
            selectedDoctorId: _selectedDoctorId,
            selectedStatus: _selectedStatus,
            onDoctorChanged: (id) => setState(() => _selectedDoctorId = id),
            onStatusChanged: (status) =>
                setState(() => _selectedStatus = status),
          ),
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator())),
          if (error != null) Expanded(child: Center(child: Text(error))),
          if (!isLoading && error == null)
            Expanded(
              child: ListView.builder(
                itemCount: filteredApps.length,
                itemBuilder: (context, index) {
                  final app = filteredApps[index];
                  return GiftCard(
                    application: app,
                    onEdit: () {
                      context.push(AppRouter.sendEditGift, extra: app);
                    },
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Gift Request'),
                          content: const Text(
                            'Are you sure you want to delete this gift request?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        notifier.deleteGiftApplication(app.requestId);
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.card_giftcard),
        label: const Text('Request gift for a doctor'),
        onPressed: () {
          context.push(AppRouter.sendEditGift);
        },
      ),
    );
  }
}
