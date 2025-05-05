import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.trailing,
    this.backgroundColor,
    this.textColor,
    this.elevation = 0,
  });

  final String text;
  final Widget icon;
  final VoidCallback onPressed;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? textColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final bgColor = backgroundColor ?? colors.background02;
    final txtColor = textColor ?? colors.active;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      elevation: elevation,
      animationDuration: const Duration(milliseconds: 200),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        splashColor: colors.primary.withOpacity(0.1),
        highlightColor: colors.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colors.background03, borderRadius: BorderRadius.circular(12)),
                child: icon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(text, style: AppTextStyle.bodyL.copyWith(color: txtColor, fontWeight: FontWeight.w500)),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
