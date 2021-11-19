import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ColorfulButton extends StatelessWidget {
  const ColorfulButton(
      {Key? key,
      required this.text,
      required this.onClick,
      required this.backgroundColor})
      : super(key: key);

  final String text;
  final Color backgroundColor;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: backgroundColor,
        shadowColor: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: DarkTextTheme.buttonL,
            ),
          ),
          onTap: () {
            onClick();
          },
        ),
      ),
    );
  }
}
