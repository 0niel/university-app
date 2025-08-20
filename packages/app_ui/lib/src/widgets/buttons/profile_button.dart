import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    required this.text,
    required this.icon,
    super.key,
    this.onPressed,
    this.trailing,
  });

  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.background03,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: 20,
                height: 20,
                child: icon,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.active,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
