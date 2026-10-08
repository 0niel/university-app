import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/widgets.dart';

class OnboardingWelcomeStep extends StatefulWidget {
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
  State<OnboardingWelcomeStep> createState() => _OnboardingWelcomeStepState();
}

class _OnboardingWelcomeStepState extends State<OnboardingWelcomeStep> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    final reduced =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (reduced) {
      _controller.jumpToPage(_page + 1);
    } else {
      unawaited(
        _controller.animateToPage(
          _page + 1,
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeOutCubic,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stories = [
      (
        feature: EntryFeature.schedule,
        title: l10n.onboardingStoryScheduleTitle,
        accent: l10n.onboardingStoryScheduleAccent,
        lead: l10n.onboardingStoryScheduleLead,
      ),
      (
        feature: EntryFeature.campus,
        title: l10n.onboardingStoryCampusTitle,
        accent: l10n.onboardingStoryCampusAccent,
        lead: l10n.onboardingStoryCampusLead,
      ),
      (
        feature: EntryFeature.community,
        title: l10n.onboardingStoryCommunityTitle,
        accent: l10n.onboardingStoryCommunityAccent,
        lead: l10n.onboardingStoryCommunityLead,
      ),
    ];
    return PageView.builder(
      key: const Key('onboarding_stories'),
      controller: _controller,
      itemCount: stories.length,
      onPageChanged: (page) => setState(() => _page = page),
      itemBuilder: (context, index) {
        final story = stories[index];
        final active = index == _page;
        final last = index == stories.length - 1;
        return AuthPageLayout(
          showBack: false,
          large: true,
          title: story.title,
          titleAccent: story.accent,
          subtitle: story.lead,
          headerTrailing: last
              ? const SizedBox(height: 44)
              : AppButton.text(
                  key: active ? const Key('onboarding_start') : null,
                  label: l10n.onboardingSkip,
                  size: AppButtonSize.small,
                  onPressed: widget.onStart,
                ),
          visual: EntryFeaturePreview(feature: story.feature),
          actions: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton.primary(
                key: active
                    ? Key(last ? 'onboarding_start' : 'onboarding_storyNext')
                    : null,
                label: last ? l10n.onboardingStart : l10n.onboardingContinue,
                size: AppButtonSize.hero,
                expanded: true,
                trailingIcon: const AppLineIconWidget(AppLineIcon.arrowRight),
                onPressed: last ? widget.onStart : _next,
              ),
              const SizedBox(height: 10),
              AppButton.text(
                key: active ? const Key('onboarding_haveAccount') : null,
                label: l10n.onboardingHaveAccount,
                size: AppButtonSize.large,
                expanded: true,
                onPressed: widget.onHaveAccount,
              ),
            ],
          ),
          child: AppStepIndicator(
            step: index + 1,
            total: stories.length,
            semanticsLabel: l10n.onboardingStepSemantics(
              index + 1,
              stories.length,
            ),
          ),
        );
      },
    );
  }
}
