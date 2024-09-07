import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.text, this.onClick, this.onLongPress}) : super(key: key);

  final String text;
  final VoidCallback? onClick;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: double.infinity, height: 48),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppTheme.colorsOf(context).primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        onPressed: () {
          onClick?.call();
        },
        onLongPress: () {
          onLongPress?.call();
        },
        child: Text(
          text,
          style: AppTextStyle.buttonS.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
