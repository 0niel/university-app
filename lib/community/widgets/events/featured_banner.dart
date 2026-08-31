part of '../featured_event_card.dart';

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.onAccentSoft.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(NinjaRadius.control),
          ),
          child: SizedBox.square(
            dimension: 44,
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            context.l10n.eventsFeaturedTag,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.microLabel.copyWith(color: colors.onAccentSoft),
          ),
        ),
      ],
    );
  }
}
