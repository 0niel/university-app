import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ShortDescriptionCard extends StatelessWidget {
  const ShortDescriptionCard({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.dark.primary.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.dark.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
