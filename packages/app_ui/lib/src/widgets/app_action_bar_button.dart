import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppActionBarButton extends StatelessWidget {
  const AppActionBarButton({
    required this.icon,
    required this.label,
    super.key,
    this.onTap,
    this.background,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  final Color? background;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        decoration: BoxDecoration(
          color: background ?? colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(
                  fontSize: 12.5,
                  color: colors.active,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
