import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  const AppDivider.inset({super.key, this.color})
      : indent = 16,
        endIndent = 0;

  final double indent;
  final double endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: SizedBox(
        width: double.infinity,
        height: 1,
        child: ColoredBox(color: color ?? context.colors.line),
      ),
    );
  }
}

class AppVerticalDivider extends StatelessWidget {
  const AppVerticalDivider({super.key, this.height, this.color});

  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: height,
      child: ColoredBox(color: color ?? context.colors.line),
    );
  }
}
