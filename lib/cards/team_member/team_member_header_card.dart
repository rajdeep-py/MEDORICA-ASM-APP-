import 'package:flutter/material.dart';
import '../../models/team_member.dart';
import '../../theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class TeamMemberHeaderCard extends StatelessWidget {
  final TeamMember member;

  const TeamMemberHeaderCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(200),
            AppColors.primary.withAlpha(100),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: member.photoUrl != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  member.photoUrl!,
                  fit: BoxFit.cover,
                ),
                // Dark overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(150),
                      ],
                    ),
                  ),
                ),
                // Member info overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: AppTypography.h2.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Iconsax.call,
                            color: AppColors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            member.phone,
                            style: AppTypography.body.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Iconsax.user,
                    color: AppColors.primary,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  member.name,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.call,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      member.phone,
                      style: AppTypography.body.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
