import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/gift.dart';
import '../../providers/auth_provider.dart';
import '../../providers/gift_provider.dart';
import '../../providers/doctor_provider.dart';

import '../../widgets/app_bar.dart';

class SendEditGiftScreen extends ConsumerStatefulWidget {
  final GiftApplication? application;
  const SendEditGiftScreen({super.key, this.application});

  @override
  ConsumerState<SendEditGiftScreen> createState() => _SendEditGiftScreenState();
}

class _SendEditGiftScreenState extends ConsumerState<SendEditGiftScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _doctorId;
  int? _giftId;
  DateTime? _giftDate;
  String? _occasion;
  String? _message;
  String? _remarks;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final app = widget.application;
    if (app != null) {
      _doctorId = app.doctorId;
      _giftId = app.giftId;
      _giftDate = app.giftDate;
      _occasion = app.occassion;
      _message = app.message;
      _remarks = app.remarks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = ref.watch(doctorProvider);
    final gifts = ref.watch(giftsProvider);
    final notifier = ref.read(giftNotifierProvider.notifier);
    final isLoading = ref.watch(isGiftLoadingProvider);
    final _ = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: widget.application == null ? 'Request Gift' : 'Edit Gift Request',
        subtitleText: 'Fill the details to ${widget.application == null ? 'request' : 'edit'} a gift',
      ),
      body: isLoading || _submitting
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _doctorId,
                      decoration: const InputDecoration(labelText: 'Doctor'),
                      items: doctors
                          .map((d) => DropdownMenuItem(
                                value: d.id,
                                child: Text(d.name),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _doctorId = val),
                      validator: (val) => val == null || val.isEmpty ? 'Select a doctor' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _giftId,
                      decoration: const InputDecoration(labelText: 'Gift Item'),
                      items: gifts
                          .map((g) => DropdownMenuItem(
                                value: g.giftId,
                                child: Text(g.productName),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _giftId = val),
                      validator: (val) => val == null ? 'Select a gift item' : null,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _giftDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _giftDate = picked);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Gift Date'),
                        child: Text(_giftDate != null
                            ? _giftDate!.toLocal().toString().split(' ').first
                            : 'Select date'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _occasion,
                      decoration: const InputDecoration(labelText: 'Occasion'),
                      onChanged: (val) => _occasion = val,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _message,
                      decoration: const InputDecoration(labelText: 'Message'),
                      onChanged: (val) => _message = val,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _remarks,
                      decoration: const InputDecoration(labelText: 'Remarks'),
                      onChanged: (val) => _remarks = val,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => _submitting = true);
                        try {
                          if (widget.application == null) {
                            await notifier.createGiftApplication(
                              doctorId: _doctorId!,
                              giftId: _giftId!,
                              occassion: _occasion,
                              message: _message,
                              giftDate: _giftDate,
                              remarks: _remarks,
                            );
                          } else {
                            await notifier.updateGiftApplication(
                              requestId: widget.application!.requestId,
                              doctorId: _doctorId,
                              occassion: _occasion,
                              message: _message,
                              giftDate: _giftDate,
                              remarks: _remarks,
                            );
                          }
                          if (mounted) Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _submitting = false);
                        }
                      },
                      child: Text(widget.application == null ? 'Request Gift' : 'Update Request'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
