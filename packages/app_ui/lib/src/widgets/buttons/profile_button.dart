import 'package:app_ui/app_ui.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    required this.text,
    required this.icon,
    super.key,
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
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).extension<AppColors>()!.background02,
          ),
        ),
        cupertino: (_, __) => CupertinoTextButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () {
          onPressed?.call();
        },
        color: Theme.of(context).extension<AppColors>()!.background02,
        child: Row(
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
                    color: Theme.of(context).extension<AppColors>()!.active,
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
