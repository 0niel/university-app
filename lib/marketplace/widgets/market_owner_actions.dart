import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MarketOwnerActions extends StatelessWidget {
  const MarketOwnerActions({
    required this.isSold,
    super.key,
    this.onToggleSold,
    this.onEdit,
    this.onArchive,
    this.onDelete,
  });

  final bool isSold;
  final VoidCallback? onToggleSold;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                label: isSold ? l10n.marketMarkAvailable : l10n.marketMarkSold,
                icon: const AppLineIconWidget(AppLineIcon.check),
                size: .large,
                expanded: true,
                onPressed: onToggleSold,
              ),
            ),
            const SizedBox(width: AppSpacing.gap),
            Expanded(
              child: AppButton.secondary(
                label: l10n.marketEdit,
                icon: const AppLineIconWidget(AppLineIcon.tag),
                size: .large,
                expanded: true,
                onPressed: onEdit,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.gap),
        Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                label: l10n.marketArchive,
                icon: const AppLineIconWidget(AppLineIcon.inbox),
                size: .large,
                expanded: true,
                onPressed: onArchive,
              ),
            ),
            const SizedBox(width: AppSpacing.gap),
            Expanded(
              child: AppButton.destructive(
                label: l10n.marketDelete,
                icon: const AppLineIconWidget(AppLineIcon.trash),
                size: .large,
                expanded: true,
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
