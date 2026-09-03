part of 'debug_overlay.dart';

class _DebugFab extends StatelessWidget {
  const _DebugFab({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: 'Debug tools',
      child: AppPressable(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface2.withValues(alpha: .72),
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: AppControlSize.touchTarget,
            child: Center(
              child: AppNinjaMark(size: 15, color: colors.accent),
            ),
          ),
        ),
      ),
    );
  }
}
