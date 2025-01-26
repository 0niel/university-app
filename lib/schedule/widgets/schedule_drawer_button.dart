import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ScheduleDrawerButton extends StatelessWidget {
  const ScheduleDrawerButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

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
                Text(text,
                    style: AppTextStyle.buttonL.copyWith(color: Theme.of(context).extension<AppColors>()!.active)),
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
