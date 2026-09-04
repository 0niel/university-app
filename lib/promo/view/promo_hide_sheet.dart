import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

enum PromoHideChoice { snooze, forever }

String promoSnoozeLabel(AppLocalizations l10n, int hours) {
  if (hours >= 24 && hours % 24 == 0) {
    return l10n.promoSnoozeDays(hours ~/ 24);
  }
  return l10n.promoSnoozeHours(hours);
}

Future<PromoHideChoice?> showPromoHideSheet(
  BuildContext context,
  PromoBanner banner,
) {
  final l10n = context.l10n;
  return showAppSheet<PromoHideChoice>(
    context,
    title: l10n.promoHideSheetTitle,
    subtitle: l10n.promoHideSheetSubtitle,
    contentPadding: EdgeInsets.zero,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (banner.allowSnooze)
          AppListRow(
            isFirst: true,
            leading: const AppIconTile(icon: AppLineIcon.clock),
            title: promoSnoozeLabel(l10n, banner.snoozeHours),
            showChevron: false,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pop(PromoHideChoice.snooze),
          ),
        if (banner.allowHideForever)
          AppListRow(
            isFirst: !banner.allowSnooze,
            leading: const AppIconTile(icon: AppLineIcon.hide),
            title: l10n.promoHideForever,
            showChevron: false,
            onTap: () => Navigator.of(
              context,
              rootNavigator: true,
            ).pop(PromoHideChoice.forever),
          ),
        const SizedBox(height: AppSpacing.sm),
      ],
    ),
  );
}
