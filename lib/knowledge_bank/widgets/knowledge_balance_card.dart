import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class KnowledgeBalanceCard extends StatelessWidget {
  const KnowledgeBalanceCard({
    required this.profile,
    this.loading = false,
    super.key,
  });

  final UserGamificationProfile profile;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final tile = DecoratedBox(
      decoration: BoxDecoration(
        color: loading
            ? colors.brandTint
            : colors.onAccentSoft.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(NinjaRadius.button),
      ),
      child: SizedBox.square(
        dimension: 44,
        child: Center(
          child: AppNinjaMark(
            size: 20,
            color: loading ? colors.brand : colors.onAccentSoft,
          ),
        ),
      ),
    );

    if (loading) {
      return Semantics(
        container: true,
        label: l10n.loadingContent,
        child: ExcludeSemantics(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(NinjaRadius.card),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  tile,
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NinjaSkeleton.bar(widthFactor: .42, height: 24),
                        SizedBox(height: 8),
                        NinjaSkeleton.bar(widthFactor: .72),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final locale = Localizations.localeOf(context).languageCode;
    final balance = NumberFormat('#,###', locale).format(profile.shurikens);
    return Semantics(
      container: true,
      label: '$balance, ${l10n.knowledgeBalanceHint}',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                tile,
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        balance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.tabular(
                          NinjaText.title.copyWith(color: colors.onAccentSoft),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.knowledgeBalanceHint,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.subtext.copyWith(
                          color: colors.onAccentSoftMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
