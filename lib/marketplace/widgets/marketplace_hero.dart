import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MarketplaceHero extends StatelessWidget {
  const MarketplaceHero({
    required this.count,
    required this.loading,
    super.key,
  });

  final int count;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: loading ? colors.surface : colors.accentSoft,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: loading
                    ? colors.brandTint
                    : colors.onAccentSoft.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(NinjaRadius.button),
              ),
              child: SizedBox.square(
                dimension: 44,
                child: Center(
                  child: ExcludeSemantics(
                    child: AppLineIconWidget(
                      AppLineIcon.tag,
                      size: 21,
                      color: loading ? colors.brand : colors.onAccentSoft,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: loading
                  ? const NinjaSkeleton.bar(widthFactor: .78, height: 16)
                  : Text(
                      l10n.marketSubtitle(count),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.body.copyWith(
                        color: colors.onAccentSoft,
                      ),
                    ),
            ),
            if (!loading) ...[
              const SizedBox(width: 10),
              Text(
                '$count',
                style: NinjaText.tabular(
                  NinjaText.title.copyWith(color: colors.onAccentSoft),
                ),
              ),
            ],
          ],
        ),
      ),
    );
    if (loading) return ExcludeSemantics(child: content);
    return Semantics(
      container: true,
      label: l10n.marketSubtitle(count),
      child: content,
    );
  }
}
