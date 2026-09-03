import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
    required this.history,
    this.onShare,
    super.key,
  });

  final int streakDays;
  final int longestStreak;
  final List<bool> history;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final record = longestStreak <= 0
        ? l10n.profileStreakHint
        : longestStreak > streakDays
        ? l10n.profileStreakRecord(longestStreak, longestStreak - streakDays)
        : l10n.profileStreakRecordBeaten;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${l10n.profileStreakDays(streakDays).trim()} · '
            '${l10n.profileStreakWord}',
            style: AppText.title.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(record, style: AppText.subtext.copyWith(color: colors.muted)),
          if (history.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            Row(
              children: [
                for (final (index, active) in history.indexed) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.fine),
                  Expanded(
                    child: Semantics(
                      label: index == history.length - 1
                          ? l10n.profileStreakToday
                          : l10n.profileStreakDaysAgo(
                              history.length - index - 1,
                            ),
                      selected: active,
                      child: SizedBox(
                        height: 56,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: active ? 1 : 0),
                            duration:
                                MediaQuery.disableAnimationsOf(context) ||
                                    MediaQuery.accessibleNavigationOf(context)
                                ? Duration.zero
                                : NinjaMotion.slow,
                            builder: (context, progress, child) => Container(
                              key: ValueKey('profile-activity-day-$index'),
                              width: double.infinity,
                              height: 8 + 48 * progress,
                              decoration: BoxDecoration(
                                color: active ? colors.accent : colors.surface2,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.focusOutline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                Text(
                  l10n.profileStreakDaysAgo(history.length - 1),
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
                Text(
                  l10n.profileStreakToday,
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ],
          if (longestStreak > 0) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.profileStreakHint,
              style: AppText.caption.copyWith(color: colors.muted),
            ),
          ],
          if (onShare != null) ...[
            const SizedBox(height: AppSpacing.md),
            AppButton.text(
              key: const ValueKey('profile-share'),
              label: l10n.share,
              icon: const AppLineIconWidget(AppLineIcon.share),
              expanded: true,
              onPressed: onShare,
            ),
          ],
        ],
      ),
    );
  }
}
