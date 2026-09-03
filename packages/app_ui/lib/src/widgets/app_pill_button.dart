import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppPillButton extends StatelessWidget {
  const AppPillButton({
    required this.label,
    required this.background,
    required this.foreground,
    super.key,
    this.onPressed,
    this.height = AppControlSize.buttonSmall,
    this.horizontalPadding = AppSpacing.fieldGap,
    this.expanded = false,
    this.textStyle,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;
  final double height;
  final double horizontalPadding;
  final bool expanded;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onPressed,
      enabled: onPressed != null,
      semanticsLabel: label,
      semanticsButton: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppControlSize.touchTarget,
          minHeight: AppControlSize.touchTarget,
        ),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            constraints: BoxConstraints(minHeight: height),
            width: expanded ? double.infinity : null,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: (textStyle ?? AppText.labelStrong).copyWith(
                  color: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
