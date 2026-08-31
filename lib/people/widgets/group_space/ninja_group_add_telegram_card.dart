import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaGroupAddTelegramCard extends StatelessWidget {
  const NinjaGroupAddTelegramCard({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: NinjaListCell(
          title: label,
          showDivider: false,
          titleColor: colors.brandInk,
          showChevron: false,
          trailing: AppLineIconWidget(.plus, size: 18, color: colors.brandInk),
          onTap: onTap,
        ),
      ),
    );
  }
}
