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
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.brandTint,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: 34,
                child: Center(
                  child: Text(
                    '$index',
                    style: NinjaText.tabular(
                      NinjaText.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.brandInk,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: NinjaText.body.copyWith(
                  height: 1.45,
                  color: colors.mutedDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
