import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../../notifiers/attendance_notifier.dart';
import '../../providers/attendance_provider.dart';

class MRAttendanceCard extends ConsumerWidget {
  const MRAttendanceCard({super.key});

  String _formatTime(DateTime? t) {
    if (t == null) return '-';
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<XFile?> _takeSelfie() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 75,
      );
      return file;
    } catch (_) {
      return null;
    }
  }

  Widget _buildAttendanceStep({required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(description, style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(todaysAttendanceProvider);
    final notifier = ref.read(attendanceNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              Row(
                children: [
                  Text('Attendance', style: AppTypography.h3.copyWith(color: AppColors.primary)),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(15),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(28),
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 24),
                                ),
                                const SizedBox(height: 20),
                                Text('How Attendance Works', style: AppTypography.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 16),
                                Text(
                                  'Secure selfie-based attendance system',
                                  style: AppTypography.body.copyWith(color: AppColors.quaternary),
                                ),
                                const SizedBox(height: 24),
                                _buildAttendanceStep(
                                  icon: Icons.camera_rounded,
                                  title: 'Capture Selfie',
                                  description: 'Take a photo using your front camera',
                                ),
                                const SizedBox(height: 16),
                                _buildAttendanceStep(
                                  icon: Icons.schedule_rounded,
                                  title: 'Timestamp Recorded',
                                  description: 'Each selfie is saved with exact time',
                                ),
                                const SizedBox(height: 16),
                                _buildAttendanceStep(
                                  icon: Icons.security_rounded,
                                  title: 'Verification',
                                  description: 'Used for security and company policy compliance',
                                ),
                                const SizedBox(height: 16),
                                _buildAttendanceStep(
                                  icon: Icons.logout_rounded,
                                  title: 'Complete Day',
                                  description: 'Check out with a selfie to finish your record',
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                      elevation: 0,
                                      minimumSize: const Size(double.infinity, 48),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Got it', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                    ),
                  ),
                  const Spacer(),
                  if (attendance != null && attendance.isCheckedIn)
                    Text('Checked in at ${_formatTime(attendance.checkIn)}', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary))
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We capture a timestamped selfie as proof of your visit. The photo and time are stored securely and used by your organization for verification.',
                style: AppTypography.description.copyWith(color: AppColors.quaternary),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (attendance == null || !attendance.isCheckedIn) ...[
                ElevatedButton.icon(
                  style: AppButtonStyles.primaryButton(),
                  onPressed: () async {
                    final file = await _takeSelfie();
                    if (file == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selfie required to Check In.')));
                      return;
                    }
                    notifier.checkIn(photoPath: file.path);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked in successfully.')));
                  },
                  icon: const Icon(Iconsax.camera),
                  label: const Text('Check In Now!'),
                ),
              ] else if (attendance.isCheckedIn && !attendance.isCheckedOut) ...[
                if (attendance.checkInPhotoPath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: AppBorderRadius.mdRadius,
                          child: Image.file(File(attendance.checkInPhotoPath!), width: double.infinity, height: 160, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Selfie captured at ${_formatTime(attendance.checkIn)}', style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary)),
                      ],
                    ),
                  ),

                
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.white,
                      elevation: AppElevation.sm,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.lgRadius),
                    ),
                    onPressed: () async {
                      final file = await _takeSelfie();
                      if (file == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selfie required to Check Out.')));
                        return;
                      }
                      notifier.checkOut(photoPath: file.path);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked out successfully.')));
                    },
                    icon: const Icon(Iconsax.camera),
                    label: const Text('Check Out...'),
                  ),
              ] else ...[
                Text('You have checked out for today at ${_formatTime(attendance.checkOut)}.', style: AppTypography.body),
                const SizedBox(height: AppSpacing.sm),
                if (attendance.checkOutPhotoPath != null)
                  ClipRRect(
                    borderRadius: AppBorderRadius.mdRadius,
                    child: Image.file(File(attendance.checkOutPhotoPath!), width: double.infinity, height: 160, fit: BoxFit.cover),
                  ),
              ],
            ],
          ),
        ),
      );
  }
}