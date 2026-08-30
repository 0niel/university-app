part of '../deadline_row.dart';

class _SwipeCompleteBackground extends StatelessWidget {
  const _SwipeCompleteBackground({required this.colors});

  final NinjaColors colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.successTint,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NinjaMetrics.screenPadding,
          ),
          child: NinjaGlyphIcon(
            NinjaGlyph.check,
            size: 22,
            color: colors.green,
          ),
        ),
      ),
    );
  }
}
