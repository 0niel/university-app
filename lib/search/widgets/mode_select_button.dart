import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ModeSelectButton extends StatefulWidget {
  const ModeSelectButton({super.key, required this.isActive, required this.text, required this.onClick, this.icon});

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
              ? WidgetStateProperty.all<Color>(Theme.of(context).extension<AppColors>()!.primary)
              : WidgetStateProperty.all<Color>(Theme.of(context).extension<AppColors>()!.background02),
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
              Theme(
                data: ThemeData(
                  iconTheme: IconThemeData(
                    color: widget.isActive
                        ? Theme.of(context).extension<AppColors>()!.active
                        : Theme.of(context).extension<AppColors>()!.deactive,
                  ),
                ),
                child: widget.icon!,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: AppTextStyle.titleS.copyWith(
                color: widget.isActive
                    ? Theme.of(context).extension<AppColors>()!.active
                    : Theme.of(context).extension<AppColors>()!.deactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
