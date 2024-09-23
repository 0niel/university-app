import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class TextOutlinedButton extends StatelessWidget {
  final String content;
  final double? width;
  final VoidCallback? onPressed;
  const TextOutlinedButton({Key? key, required this.content, this.width, this.onPressed}) : super(key: key);

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
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: AppTheme.colorsOf(context).active, width: 2),
            ),
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(50.0),
          color: AppTheme.colorsOf(context).background01,
        ),
        child: Center(
          child: Text(
            content,
            style: AppTextStyle.buttonS.copyWith(color: AppTheme.colorsOf(context).active),
          ),
        ),
      ),
    );
  }
}
