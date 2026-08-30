part of '../view/onboarding_page.dart';

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({
    required this.config,
    required this.shurikenTurns,
    required this.onContinue,
    required this.onGuest,
    super.key,
  });

  final UniversityConfig config;
  final Animation<double> shurikenTurns;
  final VoidCallback onContinue;
  final VoidCallback onGuest;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final accessible = MediaQuery.textScalerOf(context).scale(1) >= 1.6;

    return LayoutBuilder(
      builder: (context, constraints) {
        final markSize = accessible
            ? 72.0
            : (constraints.maxWidth * 0.32).clamp(96.0, 128.0);
        final gap = constraints.maxHeight >= 720 ? 30.0 : 20.0;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const .symmetric(
            horizontal: NinjaMetrics.screenPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Padding(
                    padding: const .only(top: 16),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _ShurikenMark(turns: shurikenTurns),
                    ),
                  ),
                  SizedBox(height: gap),
                  const Spacer(),
                  _WelcomeHeroCard(
                    appName: config.appName,
                    tagline: l10n.onboardingTagline,
                    markSize: markSize,
                  ),
                  SizedBox(height: gap),
                  const Spacer(),
                  NinjaButton.primary(
                    label: l10n.onboardingNext,
                    icon: const AppLineIconWidget(AppLineIcon.arrowRight),
                    expanded: true,
                    size: NinjaButtonSize.large,
                    onPressed: onContinue,
                  ),
                  const SizedBox(height: 10),
                  NinjaButton.secondary(
                    label: l10n.loginGuest,
                    expanded: true,
                    size: NinjaButtonSize.large,
                    onPressed: onGuest,
                  ),
                  Padding(
                    padding: .only(
                      top: 18,
                      bottom: bottomPadding > 0 ? 26 : 18,
                    ),
                    child: Text(
                      'open-source · ${config.webAppHost}',
                      textAlign: .center,
                      style: NinjaText.helper.copyWith(color: colors.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
