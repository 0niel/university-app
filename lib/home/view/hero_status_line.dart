part of 'home_lesson_hero.dart';

class _HeroStatusLine extends StatelessWidget {
  const _HeroStatusLine({required this.isCurrent, required this.countdown});

  final bool isCurrent;
  final String? countdown;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final countdown = this.countdown;
    return Row(
      children: [
        if (isCurrent) ...[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: colors.onAccentSoft,
              shape: .circle,
            ),
          ),
          const SizedBox(width: 7),
        ],
        Flexible(
          child: Text(
            [
              if (isCurrent) l10n.homeOngoingShort else l10n.homeNextLabel,
              ?countdown,
            ].join(' · '),
            maxLines: 1,
            overflow: .ellipsis,
            style: NinjaText.tabular(
              NinjaText.microLabel.copyWith(
                color: isCurrent
                    ? colors.onAccentSoft
                    : colors.onAccentSoftMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
