part of 'services_now_card.dart';

class _NowCta extends StatelessWidget {
  const _NowCta({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(NinjaRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: NinjaText.buttonSmall.copyWith(color: foreground),
              ),
            ),
            const SizedBox(width: 6),
            AppLineIconWidget(
              AppLineIcon.arrowRight,
              size: 14,
              color: foreground,
            ),
          ],
        ),
      ),
    );
  }
}
