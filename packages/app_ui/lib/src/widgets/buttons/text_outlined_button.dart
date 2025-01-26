import 'package:app_ui/app_ui.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

class TextOutlinedButton extends StatelessWidget {
  const TextOutlinedButton({
    required this.content,
    super.key,
    this.width,
    this.onPressed,
  });
  final String content;
  final double? width;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: PlatformElevatedButton(
        onPressed: onPressed,
        material: (_, __) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(
                color: Theme.of(context).extension<AppColors>()!.active,
                width: 2,
              ),
            ),
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).extension<AppColors>()!.background01,
        ),
        child: Center(
          child: Text(
            content,
            style: AppTextStyle.buttonS.copyWith(
              color: Theme.of(context).extension<AppColors>()!.active,
            ),
          ),
        ),
      ),
    );
  }
}
