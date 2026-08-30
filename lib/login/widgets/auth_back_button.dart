part of 'auth_page_layout.dart';

class _AuthBackButton extends StatelessWidget {
  const _AuthBackButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.back,
      semanticsButton: true,
      child: Container(
        width: NinjaMetrics.minTouchTarget,
        height: NinjaMetrics.minTouchTarget,
        alignment: .center,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          shape: .circle,
        ),
        child: AppLineIconWidget(
          AppLineIcon.chevronL,
          size: 20,
          color: colors.ink,
        ),
      ),
    );
  }
}
