part of 'home_dashboard_header.dart';

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.buttonKey,
  });

  final AppLineIcon icon;
  final String label;
  final VoidCallback onTap;
  final GlobalKey? buttonKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      child: Container(
        key: buttonKey,
        width: 44,
        height: 44,
        alignment: .center,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          shape: .circle,
        ),
        child: AppLineIconWidget(icon, size: 20, color: colors.ink),
      ),
    );
  }
}
