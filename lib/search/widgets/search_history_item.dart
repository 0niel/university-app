import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'clear_icon.dart';

class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    required this.query,
    required this.onPressed,
    required this.onClear,
    super.key,
  });

  final String query;
  final void Function(String) onPressed;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: () => onPressed(query),
      semanticsLabel: query,
      semanticsButton: true,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        padding: const .fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: .circular(AppRadius.md),
              ),
              child: AppLineIconWidget(
                .clock,
                size: 18,
                color: colors.muted,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                query,
                maxLines: 2,
                overflow: .ellipsis,
                style: AppText.body.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Tooltip(
              message: context.l10n.delete,
              child: AppPressable(
                onTap: onClear,
                semanticsLabel: context.l10n.delete,
                semanticsButton: true,
                child: const SizedBox.square(
                  dimension: AppControlSize.iconButton,
                  child: Center(
                    child: _ClearIcon(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
