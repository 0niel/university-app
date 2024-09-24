import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.trailing,
  });

  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: PlatformTextButton(
        material: (_, __) => MaterialTextButtonData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            backgroundColor: AppTheme.colorsOf(context).background02,
          ),
        ),
        cupertino: (_, __) => CupertinoTextButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: () {
          onPressed?.call();
        },
        color: AppTheme.colorsOf(context).background02,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: icon,
                ),
                Text(
                  text,
                  style: AppTextStyle.buttonL.copyWith(
                    color: AppTheme.colorsOf(context).active,
                  ),
                ),
              ],
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}
