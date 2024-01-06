import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ShortDescriptionCard extends StatelessWidget {
  const ShortDescriptionCard({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppTheme.colors.primary.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.colors.primary,
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
