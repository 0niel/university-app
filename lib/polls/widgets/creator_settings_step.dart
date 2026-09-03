part of 'poll_creator_sheet.dart';

class _SettingsStep extends StatelessWidget {
  const _SettingsStep({
    required this.anonymous,
    required this.onAnonymousChanged,
    required this.resultsVisibility,
    required this.onResultsVisibilityChanged,
    required this.allowChange,
    required this.onAllowChangeChanged,
    required this.closesEnabled,
    required this.closesAt,
    required this.onClosesCleared,
    required this.onPickDate,
    required this.onPickTime,
    required this.onPreset,
  });

  final bool anonymous;
  final ValueChanged<bool> onAnonymousChanged;
  final PollResultsVisibility resultsVisibility;
  final ValueChanged<PollResultsVisibility> onResultsVisibilityChanged;
  final bool allowChange;
  final ValueChanged<bool> onAllowChangeChanged;
  final bool closesEnabled;
  final DateTime? closesAt;
  final VoidCallback onClosesCleared;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final ValueChanged<int> onPreset;

  String _visibilityLabel(AppLocalizations l10n, PollResultsVisibility value) =>
      switch (value) {
        PollResultsVisibility.always => l10n.pollsResultsVisibilityAlways,
        PollResultsVisibility.afterVote => l10n.pollsResultsVisibilityAfterVote,
        PollResultsVisibility.afterClose =>
          l10n.pollsResultsVisibilityAfterClose,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final at = closesAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsToggle(
          title: l10n.pollsAnonymous,
          subtitle: l10n.pollsAnonymousSub,
          value: anonymous,
          onChanged: onAnonymousChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        _SettingsToggle(
          title: l10n.pollsAllowChange,
          value: allowChange,
          onChanged: onAllowChangeChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.pollsResultsVisibility,
          style: AppText.captionStrong.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in PollResultsVisibility.values)
              AppChip.filter(
                label: _visibilityLabel(l10n, value),
                selected: resultsVisibility == value,
                onTap: () => onResultsVisibilityChanged(value),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.pollsClosesAt,
          style: AppText.captionStrong.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppChip.filter(
              label: l10n.pollsClosesAtNone,
              selected: !closesEnabled,
              onTap: onClosesCleared,
            ),
            for (final (days, label) in [
              (1, l10n.pollsExpiry24h),
              (3, l10n.pollsExpiry3d),
              (7, l10n.pollsExpiry7d),
            ])
              AppChip.filter(
                label: label,
                onTap: () => onPreset(days),
              ),
            AppChip.filter(
              label: closesEnabled && at != null
                  ? DateFormat('d MMM, HH:mm', locale).format(at)
                  : l10n.pollsClosesAtPick,
              selected: closesEnabled,
              onTap: onPickDate,
            ),
          ],
        ),
        if (closesEnabled) ...[
          const SizedBox(height: AppSpacing.xxs),
          AppButton.text(
            label: DateFormat.Hm(locale).format(at ?? DateTime.now()),
            onPressed: onPickTime,
          ),
        ],
      ],
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = this.subtitle;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppText.body.copyWith(
                  color: colors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        AppToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}
