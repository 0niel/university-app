import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeEmptyRow extends StatelessWidget {
  const HomeEmptyRow({required this.text, required this.onTap, super.key});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: text,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        padding: const .fromLTRB(16, 18, 12, 18),
        child: Row(
          children: [
            AppLineIconWidget(.check, size: 19, color: colors.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: NinjaText.body.copyWith(color: colors.mutedDark),
              ),
            ),
            AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
          ],
        ),
      ),
    );
  }
}
