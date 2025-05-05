import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class SettingsItem extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final Widget? trailing;

  const SettingsItem({super.key, required this.text, required this.icon, this.onPressed, this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).extension<AppColors>()!.background03,
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon,
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(text, style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w500))),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
