part of '../view/onboarding_page.dart';

class _OnboardStep extends StatelessWidget {
  const _OnboardStep({
    required this.step,
    required this.total,
    required this.ctaLabel,
    required this.child,
    this.showBack = false,
    this.onBack,
    this.onCta,
    this.ctaEnabled = true,
    this.ctaLoading = false,
  });

  final int step;
  final int total;
  final String ctaLabel;
  final Widget child;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onCta;
  final bool ctaEnabled;
  final bool ctaLoading;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _OnboardHeader(
          step: step,
          total: total,
          onBack: showBack ? onBack : null,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              26,
              NinjaMetrics.screenPadding,
              0,
            ),
            child: child,
          ),
        ),
        Padding(
          padding: .fromLTRB(
            NinjaMetrics.screenPadding,
            14,
            NinjaMetrics.screenPadding,
            bottomPadding > 0 ? 34 : 18,
          ),
          child: NinjaButton.primary(
            label: ctaLabel,
            expanded: true,
            size: NinjaButtonSize.large,
            loading: ctaLoading,
            onPressed: ctaEnabled ? onCta : null,
          ),
        ),
      ],
    );
  }
}
