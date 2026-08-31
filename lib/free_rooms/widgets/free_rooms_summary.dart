import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FreeRoomsSummary extends StatelessWidget {
  const FreeRoomsSummary({
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
    final time = DateFormat.Hm(
      Localizations.localeOf(context).languageCode,
    ).format(DateTime.now());
    final accented = !loading;
    return Semantics(
      container: true,
      label: loading
          ? l10n.loadingContent
          : '$count ${l10n.freeRoomsSummaryLabel}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accented ? colors.accentSoft : colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accented
                      ? colors.onAccentSoft.withValues(alpha: .12)
                      : colors.brandTint,
                  borderRadius: .circular(NinjaRadius.control),
                ),
                child: SizedBox.square(
                  dimension: NinjaMetrics.minTouchTarget,
                  child: Center(
                    child: AppLineIconWidget(
                      .door,
                      color: accented ? colors.onAccentSoft : colors.brand,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      l10n.freeRoomsSummaryLabel,
                      style: NinjaText.headline.copyWith(
                        color: accented ? colors.onAccentSoft : colors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.freeRoomsNow(time),
                      style: NinjaText.subtext.copyWith(
                        color: accented
                            ? colors.onAccentSoftMuted
                            : colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (loading)
                const NinjaSkeleton(
                  width: 34,
                  height: 26,
                  radius: NinjaRadius.pill,
                )
              else
                Text(
                  '$count',
                  style: NinjaText.tabular(
                    NinjaText.title.copyWith(color: colors.onAccentSoft),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
