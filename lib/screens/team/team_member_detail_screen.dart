import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/team_member.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/team_member/team_member_header_card.dart';
import '../../cards/team_member/team_member_contact_card.dart';
import '../../cards/team_member/team_member_work_area_card.dart';

class TeamMemberDetailScreen extends StatelessWidget {
  final TeamMember member;

  const TeamMemberDetailScreen({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: member.name,
        subtitleText: member.phone,
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card with member photo
            TeamMemberHeaderCard(member: member),
            
            // Contact Information Card
            TeamMemberContactCard(member: member),
            
            // Work Area Card
            TeamMemberWorkAreaCard(member: member),
            
            // Set Monthly Target Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening monthly target setup for ${member.name}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Iconsax.location, size: 20),
                  label: const Text(
                    'Set Monthly Target',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
