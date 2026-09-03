import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';

class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel(
    this.text, {
    super.key,
    this.hint,
    this.bottom = 6,
    this.color,
  });

  final String text;
  final String? hint;
  final double bottom;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hint = this.hint;
    final style = AppText.caption.copyWith(color: color ?? colors.muted);
    if (hint == null) {
      return Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Text(text, style: style),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Text.rich(
        TextSpan(
          text: text,
          children: [
            TextSpan(
              text: ' · $hint',
              style: TextStyle(color: colors.muted2),
            ),
          ],
        ),
        style: style,
      ),
    );
  }
}
