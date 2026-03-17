import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/gift.dart';
import '../../providers/auth_provider.dart';
import '../../providers/gift_provider.dart';
import '../../providers/doctor_provider.dart';

import '../../widgets/app_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

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
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      decoration: AppCardStyles.inputFieldCard(),
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: DropdownButtonFormField<String>(
                        initialValue: _doctorId,
                        decoration: InputDecoration(
                          labelText: 'Doctor',
                          prefixIcon: const Icon(Iconsax.user, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          filled: true,
                          fillColor: AppColors.surface200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        ),
                        icon: const Icon(Iconsax.arrow_down_1, color: AppColors.primary),
                        dropdownColor: AppColors.white,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
                        items: doctors
                            .map((d) => DropdownMenuItem(
                                  value: d.id,
                                  child: Row(
                                    children: [
                                      const Icon(Iconsax.user, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text(d.name),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _doctorId = val),
                        validator: (val) => val == null || val.isEmpty ? 'Select a doctor' : null,
                      ),
                    ),
                    Container(
                      decoration: AppCardStyles.inputFieldCard(),
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: DropdownButtonFormField<int>(
                        initialValue: _giftId,
                        decoration: InputDecoration(
                          labelText: 'Gift Item',
                          prefixIcon: const Icon(Iconsax.gift, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          filled: true,
                          fillColor: AppColors.surface200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        ),
                        icon: const Icon(Iconsax.arrow_down_1, color: AppColors.primary),
                        dropdownColor: AppColors.white,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
                        items: gifts
                            .map((g) => DropdownMenuItem(
                                  value: g.giftId,
                                  child: Row(
                                    children: [
                                      const Icon(Iconsax.gift, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text(g.productName),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _giftId = val),
                        validator: (val) => val == null ? 'Select a gift item' : null,
                      ),
                    ),
                    Container(
                      decoration: AppCardStyles.inputFieldCard(),
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
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
                          decoration: InputDecoration(
                            labelText: 'Gift Date',
                            prefixIcon: const Icon(Iconsax.calendar, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                            filled: true,
                            fillColor: AppColors.surface200,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                          ),
                          child: Text(
                            _giftDate != null
                                ? _giftDate!.toLocal().toString().split(' ').first
                                : 'Select date',
                            style: AppTypography.bodyLarge.copyWith(
                              color: _giftDate != null ? AppColors.primary : AppColors.quaternary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: AppCardStyles.inputFieldCard(),
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: TextFormField(
                        initialValue: _occasion,
                        decoration: InputDecoration(
                          labelText: 'Occasion',
                          prefixIcon: const Icon(Iconsax.star, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          filled: true,
                          fillColor: AppColors.surface200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        ),
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
                        onChanged: (val) => _occasion = val,
                      ),
                    ),
                    Container(
                      decoration: AppCardStyles.inputFieldCard(),
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: TextFormField(
                        initialValue: _message,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          prefixIcon: const Icon(Iconsax.message, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          filled: true,
                          fillColor: AppColors.surface200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        ),
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
                        onChanged: (val) => _message = val,
                      ),
                    ),
                    Container(
                      decoration: AppCardStyles.inputFieldCard(),
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: TextFormField(
                        initialValue: _remarks,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Remarks',
                          prefixIcon: const Icon(Iconsax.note, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.divider, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          filled: true,
                          fillColor: AppColors.surface200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        ),
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
                        onChanged: (val) => _remarks = val,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ElevatedButton.icon(
                      style: AppButtonStyles.primaryButton(),
                      icon: Icon(widget.application == null ? Iconsax.send_2 : Iconsax.edit, size: 20),
                      label: Text(widget.application == null ? 'Request Gift' : 'Update Request'),
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
