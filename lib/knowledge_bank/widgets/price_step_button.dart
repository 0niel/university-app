part of 'material_upload_sheet.dart';

class _PriceStepButton extends StatelessWidget {
  const _PriceStepButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
  });

  final AppLineIcon icon;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: AppPressable(
        pressedScale: 0.9,
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? colors.surfaceAlt : colors.surface,
          ),
          child: AppLineIconWidget(
            icon,
            size: 16,
            color: enabled ? colors.ink : colors.disabled,
          ),
        ),
      ),
    );
  }
}
