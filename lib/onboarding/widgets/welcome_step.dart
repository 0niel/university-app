import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/widgets.dart';

class OnboardingWelcomeStep extends StatelessWidget {
  const OnboardingWelcomeStep({
    required this.totalSteps,
    required this.onStart,
    required this.onHaveAccount,
    super.key,
  });

  final int totalSteps;
  final VoidCallback onStart;
  final VoidCallback onHaveAccount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return AuthPageLayout(
      step: 1,
      totalSteps: totalSteps,
      showBack: false,
      large: true,
      leading: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.accent,
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        child: AppLineIconWidget(
          AppLineIcon.school,
          size: 28,
          color: colors.onAccent,
          strokeWidth: 2.2,
        ),
      ),
      title: l10n.onboardingWelcomeTitle,
      titleAccent: l10n.onboardingWelcomeTitleAccent,
      subtitle: l10n.onboardingWelcomeLead,
      actions: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton.primary(
            key: const Key('onboarding_start'),
            label: l10n.onboardingStart,
            size: AppButtonSize.hero,
            expanded: true,
            onPressed: onStart,
          ),
          const SizedBox(height: 10),
          AppButton.text(
            key: const Key('onboarding_haveAccount'),
            label: l10n.onboardingHaveAccount,
            size: AppButtonSize.large,
            expanded: true,
            foregroundColor: colors.muted,
            onPressed: onHaveAccount,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHintCard(
              icon: AppLineIcon.calendar,
              color: colors.practice,
              radius: AppRadius.none,
              title: l10n.onboardingFeatureScheduleTitle,
              subtitle: l10n.onboardingFeatureScheduleSub,
            ),
            const SizedBox(height: 2),
            AuthHintCard(
              icon: AppLineIcon.door,
              color: colors.lecture,
              radius: AppRadius.none,
              title: l10n.onboardingFeatureRoomsTitle,
              subtitle: l10n.onboardingFeatureRoomsSub,
            ),
            const SizedBox(height: 2),
            AuthHintCard(
              icon: AppLineIcon.people,
              color: colors.lab,
              radius: AppRadius.none,
              title: l10n.onboardingFeatureFriendsTitle,
              subtitle: l10n.onboardingFeatureFriendsSub,
            ),
          ],
        ),
      ),
    );
  }
}
