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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.colorsOf(context).background01),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(color: AppTheme.colorsOf(context).primary, width: 2)),
          ),
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
