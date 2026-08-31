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
    final colors = context.ninja;
    final l10n = context.l10n;
    final statusColor = item.status == .found ? colors.green : colors.amberInk;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
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
                style: NinjaText.microLabel.copyWith(color: colors.ink),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          item.itemName,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${item.actionLine(l10n, item.authorDisplayName(l10n))} · '
          '${relativeTime(l10n, item.createdAt)}',
          style: NinjaText.subtext.copyWith(color: colors.mutedDark),
        ),
      ],
    );
  }
}
