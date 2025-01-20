import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onClick,
    this.onLongPress,
    this.enabled = true,
  });

  final String text;
  final bool enabled;
  final Widget? icon;
  final VoidCallback? onClick;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: double.infinity, height: 48),
      child: PlatformElevatedButton(
        material: (_, __) => MaterialElevatedButtonData(
          onLongPress: enabled ? onLongPress : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            backgroundColor: enabled ? AppTheme.colorsOf(context).primary : Colors.grey,
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(24.0),
          color: enabled ? AppTheme.colorsOf(context).primary : Colors.grey,
        ),
        onPressed: enabled ? onClick : null,
        color: enabled ? AppTheme.colorsOf(context).primary : Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 8.0),
            Text(
              text,
              style: AppTextStyle.buttonS.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
