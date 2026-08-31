part of '../view/onboarding_page.dart';

class _WelcomeHeroCard extends StatelessWidget {
  const _WelcomeHeroCard({
    required this.appName,
    required this.tagline,
    required this.markSize,
  });

  final String appName;
  final String tagline;
  final double markSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const .fromLTRB(24, 26, 24, 26),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            _NinjaHero(size: markSize, color: colors.onAccentSoft),
            const SizedBox(height: 24),
            Text(
              appName,
              style: NinjaText.display.copyWith(color: colors.onAccentSoft),
            ),
            const SizedBox(height: 10),
            Text(
              tagline,
              style: NinjaText.body.copyWith(color: colors.onAccentSoftMuted),
            ),
          ],
        ),
      ),
    );
  }
}
