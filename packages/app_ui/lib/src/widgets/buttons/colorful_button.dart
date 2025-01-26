import 'package:app_ui/app_ui.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

class ColorfulButton extends StatelessWidget {
  const ColorfulButton({
    required this.text,
    required this.onClick,
    required this.backgroundColor,
    super.key,
  });

  final String text;
  final Color backgroundColor;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: PlatformTextButton(
        onPressed: onClick,
        material: (_, __) => MaterialTextButtonData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: backgroundColor,
          ),
        ),
        cupertino: (_, __) => CupertinoTextButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.buttonL.copyWith(
              color: Theme.of(context).extension<AppColors>()!.active,
            ),
          ),
        ),
      ),
    );
  }
}
