import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ModeSelectButton extends StatefulWidget {
  const ModeSelectButton({Key? key, required this.isActive, required this.text, required this.onClick, this.icon})
      : super(key: key);

  final bool isActive;
  final String text;
  final VoidCallback onClick;
  final Widget? icon;

  @override
  State<ModeSelectButton> createState() => _ModeSelectButtonState();
}

class _ModeSelectButtonState extends State<ModeSelectButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () {
          widget.onClick();
        },
        style: ButtonStyle(
          backgroundColor: widget.isActive
              ? WidgetStateProperty.all<Color>(AppTheme.colorsOf(context).primary)
              : WidgetStateProperty.all<Color>(AppTheme.colorsOf(context).background02),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 8)),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
        ),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: widget.isActive ? AppTheme.colorsOf(context).active : AppTheme.colorsOf(context).deactive,
                ),
                child: widget.icon!,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: AppTextStyle.titleS.copyWith(
                color: widget.isActive ? AppTheme.colorsOf(context).active : AppTheme.colorsOf(context).deactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
