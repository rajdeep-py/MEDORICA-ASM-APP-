import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';

class AboutUsContactUsCard extends StatelessWidget {
  final String phone;
  final String email;
  final String address;
  final String mapUrl;
  final String website;
  final String instagram;
  final String facebook;
  final String youtube;
  final String linkedin;

  const AboutUsContactUsCard({
    super.key,
    required this.phone,
    required this.email,
    required this.address,
    required this.mapUrl,
    required this.website,
    required this.instagram,
    required this.facebook,
    required this.youtube,
    required this.linkedin,
  });

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Icon(
                    Iconsax.call,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Contact Us',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Phone
            _buildContactItem(
              icon: Iconsax.call,
              title: 'Phone',
              value: phone,
              onTap: () => _launchUrl('tel:${phone.replaceAll(' ', '')}'),
            ),
            const SizedBox(height: AppSpacing.md),
            // Email
            _buildContactItem(
              icon: Iconsax.sms,
              title: 'Email',
              value: email,
              onTap: () => _launchUrl('mailto:$email'),
            ),
            const SizedBox(height: AppSpacing.md),
            // Address
            _buildContactItem(
              icon: Iconsax.location,
              title: 'Address',
              value: address,
              onTap: () => _launchUrl(mapUrl),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Social Media Links
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Follow Us',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.quaternary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: Iconsax.global,
                  label: 'Website',
                  onTap: () => _launchUrl(website),
                  color: const Color(0xFF4285F4),
                ),
                _buildSocialButton(
                  icon: Iconsax.instagram,
                  label: 'Instagram',
                  onTap: () => _launchUrl(instagram),
                  color: const Color(0xFFE4405F),
                ),
                _buildSocialButton(
                  icon: Iconsax.video,
                  label: 'YouTube',
                  onTap: () => _launchUrl(youtube),
                  color: const Color(0xFFFF0000),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: Iconsax.message_2,
                  label: 'Facebook',
                  onTap: () => _launchUrl(facebook),
                  color: const Color(0xFF1877F2),
                ),
                _buildSocialButton(
                  icon: Iconsax.link,
                  label: 'LinkedIn',
                  onTap: () => _launchUrl(linkedin),
                  color: const Color(0xFF0A66C2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.quaternary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Iconsax.arrow_right_3,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
