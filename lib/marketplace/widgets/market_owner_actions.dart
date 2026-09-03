import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MarketOwnerActions extends StatelessWidget {
  const MarketOwnerActions({
    required this.isSold,
    required this.isBusy,
    required this.onToggleSold,
    required this.onDelete,
    super.key,
  });

  final bool isSold;
  final bool isBusy;
  final VoidCallback onToggleSold;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NinjaIconButton(
          tooltip: isSold
              ? context.l10n.marketMarkAvailable
              : context.l10n.marketMarkSold,
          onPressed: isBusy ? null : onToggleSold,
          icon: AppLineIconWidget(
            AppLineIcon.check,
            color: isSold ? colors.accent : colors.ink,
          ),
        ),
        NinjaIconButton(
          tooltip: context.l10n.marketDelete,
          onPressed: isBusy ? null : onDelete,
          icon: AppLineIconWidget(
            AppLineIcon.trash,
            color: colors.exam,
          ),
        ),
      ],
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: isBusy ? 0.35 : 1,
          duration: const Duration(milliseconds: 160),
          child: actions,
        ),
        if (isBusy) const NinjaSpinner(size: 16, strokeWidth: 2.5),
      ],
    );
  }
}
