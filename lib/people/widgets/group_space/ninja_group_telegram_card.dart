import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaGroupTelegramCard extends StatelessWidget {
  const NinjaGroupTelegramCard({
    required this.link,
    required this.onOpen,
    this.onDelete,
    super.key,
  });

  final GroupLink link;
  final VoidCallback onOpen;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onDelete = this.onDelete;
    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.screen),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Row(
          children: [
            Expanded(
              child: NinjaListCell(
                title: link.title,
                subtitle: link.safeUri?.path ?? link.url,
                showDivider: false,
                trailingLabel: context.l10n.groupSpaceOpen,
                trailingColor: colors.accent,
                showChevron: false,
                onTap: onOpen,
              ),
            ),
            if (onDelete != null)
              Padding(
                padding: const .only(right: 12),
                child: NinjaIconButton(
                  icon: const AppLineIconWidget(.trash, size: 20),
                  tooltip: context.l10n.delete,
                  onPressed: onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
