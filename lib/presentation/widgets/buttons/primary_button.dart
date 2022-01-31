import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.text, required this.onClick})
      : super(key: key);

  final String text;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints.tightFor(width: double.infinity, height: 48),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(DarkThemeColors.primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        onPressed: () {
          onClick();
        },
        child: Text(
          text,
          style: DarkTextTheme.buttonS,
        ),
      ),
    );
  }
}
