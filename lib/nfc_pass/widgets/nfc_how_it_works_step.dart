import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NfcHowItWorksStep extends StatelessWidget {
  const NfcHowItWorksStep({
    required this.index,
    required this.text,
    super.key,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.tint,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: 34,
                child: Center(
                  child: Text(
                    '$index',
                    style: AppText.tabular(
                      AppText.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.accent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                text,
                style: AppText.body.copyWith(
                  height: 1.45,
                  color: colors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
