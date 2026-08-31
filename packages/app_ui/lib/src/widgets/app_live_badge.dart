import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppLiveBadge extends StatelessWidget {
  const AppLiveBadge({super.key, this.label = 'Сейчас'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: colors.onAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppText.captionSmall.copyWith(
              color: colors.onAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
