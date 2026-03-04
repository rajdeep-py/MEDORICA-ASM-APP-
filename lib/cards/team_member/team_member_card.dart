import 'package:flutter/material.dart';
import '../../models/team_member.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final VoidCallback? onTap;

  const TeamMemberCard({
    super.key,
    required this.member,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.primaryLight, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Profile Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: member.photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          member.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Iconsax.user,
                        color: AppColors.primary,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 12),
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Iconsax.call,
                          color: AppColors.quaternary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          member.phone,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.quaternary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrow Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.arrow_right,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
