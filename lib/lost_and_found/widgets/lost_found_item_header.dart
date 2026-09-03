import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/utils/utils.dart';

class LostFoundItemHeader extends StatelessWidget {
  const LostFoundItemHeader({required this.item, super.key});

  final LostFoundItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final statusColor = item.status == .found ? colors.lecture : colors.warn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                item.status == .found
                    ? l10n.lostFoundTagFound
                    : l10n.lostFoundTagSearching,
                style: AppText.captionSmall.copyWith(color: colors.ink),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          item.itemName,
          style: AppText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${item.actionLine(l10n, item.authorDisplayName(l10n))} · '
          '${relativeTime(l10n, item.createdAt)}',
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
