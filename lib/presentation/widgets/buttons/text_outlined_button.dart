import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class TextOutlinedButton extends StatelessWidget {
  final String content;
  final double width;
  final VoidCallback? onPressed;
  const TextOutlinedButton(
      {Key? key, required this.content, required this.width, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(DarkThemeColors.background01),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side:
                    const BorderSide(color: DarkThemeColors.primary, width: 2)),
          ),
        ),
        child: Center(
          child: Text(content,
              style: const TextStyle(fontSize: 17, color: Colors.white)),
        ),
      ),
    );
  }
}
