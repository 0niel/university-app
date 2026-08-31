part of '../deadline_row.dart';

class _CompletionButton extends StatelessWidget {
  const _CompletionButton({
    required this.checked,
    required this.enabled,
    required this.reduceMotion,
    required this.onPressed,
  });

  final bool checked;
  final bool enabled;
  final bool reduceMotion;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      button: true,
      checked: checked,
      enabled: enabled,
      label: checked
          ? context.l10n.deadlineMarkActive
          : context.l10n.deadlineMarkDone,
      child: SizedBox.square(
        dimension: 44,
        child: AppPressable(
          enabled: enabled,
          onTap: enabled
              ? () {
                  unawaited(HapticFeedback.lightImpact());
                  onPressed();
                }
              : null,
          child: Center(
            child: AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: checked ? colors.brand : colors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: NinjaGlyphIcon(
                NinjaGlyph.check,
                size: 15,
                color: checked ? colors.onBrand : colors.disabled,
                strokeWidth: 2.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
