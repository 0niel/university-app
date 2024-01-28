import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ScheduleDrawerButton extends StatelessWidget {
  const ScheduleDrawerButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: TextButton(
            onPressed: onTap,
            child: Row(
              children: [
                icon,
                const SizedBox(width: 20),
                Text(text, style: AppTextStyle.buttonL.copyWith(color: AppTheme.colorsOf(context).active)),
              ],
            ),
          ),
        ),
        Opacity(
          opacity: 0.05,
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
