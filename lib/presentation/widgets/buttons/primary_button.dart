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
  });

  final String text;
  final Widget? icon;
  final VoidCallback? onClick;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: double.infinity, height: 48),
      child: PlatformElevatedButton(
        // style: ButtonStyle(
        //   backgroundColor: WidgetStateProperty.all(AppTheme.colorsOf(context).primary),
        //   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(24.0),
        //     ),
        //   ),
        // ),
        material: (_, __) => MaterialElevatedButtonData(
          onLongPress: onLongPress,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(24.0),
        ),

        onPressed: () {
          onClick?.call();
        },
        color: AppTheme.colorsOf(context).primary,
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
