import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/widgets.dart';

enum _WelcomeStory { schedule, campus, community }

class OnboardingWelcomeStep extends StatefulWidget {
  const OnboardingWelcomeStep({
    required this.totalSteps,
    required this.onStart,
    required this.onHaveAccount,
    super.key,
    this.onTeacherStart,
  });

  final int totalSteps;
  final VoidCallback onStart;
  final VoidCallback onHaveAccount;
  final VoidCallback? onTeacherStart;

  @override
  State<OnboardingWelcomeStep> createState() => _OnboardingWelcomeStepState();
}

class _OnboardingWelcomeStepState extends State<OnboardingWelcomeStep> {
  _WelcomeStory _story = _WelcomeStory.schedule;
  double _dragDistance = 0;

  void _next() => _select(_story.index + 1);

  void _select(int index) {
    final next = _WelcomeStory.values[index.clamp(0, 2)];
    if (next != _story) setState(() => _story = next);
  }

  void _swipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (_dragDistance.abs() < 48 && velocity.abs() < 300) return;
    final direction = _dragDistance.abs() >= 48 ? _dragDistance : velocity;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final forward = rtl ? direction > 0 : direction < 0;
    _select(_story.index + (forward ? 1 : -1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final story = switch (_story) {
      _WelcomeStory.schedule => (
        feature: EntryFeature.schedule,
        title: l10n.onboardingStoryScheduleTitle,
        accent: l10n.onboardingStoryScheduleAccent,
        lead: l10n.onboardingStoryScheduleLead,
      ),
      _WelcomeStory.campus => (
        feature: EntryFeature.campus,
        title: l10n.onboardingStoryCampusTitle,
        accent: l10n.onboardingStoryCampusAccent,
        lead: l10n.onboardingStoryCampusLead,
      ),
      _WelcomeStory.community => (
        feature: EntryFeature.community,
        title: l10n.onboardingStoryCommunityTitle,
        accent: l10n.onboardingStoryCommunityAccent,
        lead: l10n.onboardingStoryCommunityLead,
      ),
    };
    final last = _story == _WelcomeStory.community;
    return GestureDetector(
      key: const Key('onboarding_stories'),
      onHorizontalDragStart: (_) => _dragDistance = 0,
      onHorizontalDragUpdate: (details) =>
          _dragDistance += details.primaryDelta ?? 0,
      onHorizontalDragEnd: _swipe,
      child: AuthPageLayout(
        presentation: AppEntryPresentation.staged,
        contentIdentity: _story,
        showBack: false,
        large: true,
        title: story.title,
        titleAccent: story.accent,
        subtitle: story.lead,
        headerTrailing: last
            ? const SizedBox(height: 44)
            : AppButton.text(
                key: const Key('onboarding_start'),
                label: l10n.onboardingSkip,
                size: AppButtonSize.small,
                onPressed: widget.onStart,
              ),
        headerContent: AppStepIndicator(
          step: _story.index + 1,
          total: _WelcomeStory.values.length,
          semanticsLabel: l10n.onboardingStepSemantics(
            _story.index + 1,
            _WelcomeStory.values.length,
          ),
        ),
        visual: EntryFeaturePreview(feature: story.feature),
        actions: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton.primary(
              key: Key(last ? 'onboarding_start' : 'onboarding_storyNext'),
              label: last ? l10n.onboardingStart : l10n.onboardingContinue,
              size: AppButtonSize.hero,
              expanded: true,
              trailingIcon: const AppLineIconWidget(AppLineIcon.arrowRight),
              onPressed: last ? widget.onStart : _next,
            ),
            const SizedBox(height: 10),
            if (widget.onTeacherStart != null) ...[
              AppButton.secondary(
                key: const Key('onboarding_teacherStart'),
                label: l10n.teacherRoleFallback,
                size: AppButtonSize.large,
                expanded: true,
                onPressed: widget.onTeacherStart,
              ),
              const SizedBox(height: 10),
            ],
            AppButton.text(
              key: const Key('onboarding_haveAccount'),
              label: l10n.onboardingHaveAccount,
              size: AppButtonSize.large,
              expanded: true,
              onPressed: widget.onHaveAccount,
            ),
          ],
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }
}
