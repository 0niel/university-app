import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';

Future<void> shareProfileLink(BuildContext context) async {
  final l10n = context.l10n;
  try {
    await Clipboard.setData(
      ClipboardData(text: DeepLinks.appLink('/profile').toString()),
    );
    if (context.mounted) {
      ToastManager.showSuccess(context, message: l10n.profileLinkCopied);
    }
  } on Exception {
    if (context.mounted) ToastManager.showError(context, message: l10n.error);
  }
}

class ProfileActivityCard extends StatelessWidget {
  const ProfileActivityCard({
    required this.streakDays,
    required this.longestStreak,
    required this.days,
    this.onShare,
    super.key,
  });

  final int streakDays;
  final int longestStreak;
  final List<ActivityDay> days;
  final VoidCallback? onShare;

  static String _capitalize(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toString();
    final hasRecord = longestStreak > 0;
    final record = !hasRecord
        ? l10n.profileStreakHint
        : longestStreak > streakDays
        ? l10n.profileStreakRecord(longestStreak, longestStreak - streakDays)
        : l10n.profileStreakRecordBeaten;
    final today = days.isEmpty
        ? null
        : days.map((entry) => entry.day).reduce(
            (a, b) => a.isAfter(b) ? a : b,
          );
    final weekdayLabels = List<String?>.generate(7, (index) {
      if (index != 0 && index != 2 && index != 4) return null;
      return _capitalize(
        DateFormat.E(locale).format(DateTime(2024, 1, 1 + index)),
      );
    });

    return AppStreakCalendarCard(
      streakDays: streakDays,
      days: [
        for (final entry in days)
          AppHeatmapDay(date: entry.day, count: entry.count),
      ],
      streakDaysLabel: l10n.profileStreakDays(streakDays).trim(),
      streakWordLabel: ' · ${l10n.profileStreakWord}',
      hintLabel: l10n.profileStreakHint,
      recordLabel: record,
      today: today,
      weekdayLabels: weekdayLabels,
      monthLabelBuilder: (date) =>
          _capitalize(DateFormat.MMM(locale).format(date)),
      tooltipBuilder: (date, count) => l10n.profileActivityTooltip(
        DateFormat.MMMd(locale).format(date),
        count,
      ),
      legendLessLabel: l10n.profileActivityLegendLess,
      legendMoreLabel: l10n.profileActivityLegendMore,
      trailing: onShare == null && !hasRecord
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasRecord)
                  Text(
                    l10n.profileStreakHint,
                    style: AppText.caption.copyWith(color: colors.muted),
                  ),
                if (hasRecord && onShare != null)
                  const SizedBox(height: AppSpacing.md),
                if (onShare != null)
                  AppButton.text(
                    key: const ValueKey('profile-share'),
                    label: l10n.share,
                    icon: const AppLineIconWidget(AppLineIcon.share),
                    expanded: true,
                    onPressed: onShare,
                  ),
              ],
            ),
    );
  }
}
