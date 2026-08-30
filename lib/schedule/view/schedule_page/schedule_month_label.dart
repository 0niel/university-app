part of '../schedule_page.dart';

class _ScheduleMonthLabel extends StatelessWidget {
  const _ScheduleMonthLabel({required this.day, required this.onTap});

  final DateTime day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final month = capitalizeFirst(DateFormat('LLLL', locale).format(day));
    final week = studyWeekNumber(day);
    final label = week > 0 ? '$month · ${l10n.studyWeekNumber(week)}' : month;

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        2,
      ),
      child: Semantics(
        button: true,
        child: AppPressable(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 30),
            alignment: .centerLeft,
            child: Row(
              mainAxisSize: .min,
              children: [
                Flexible(
                  child: NinjaStateSwitcher(
                    duration: NinjaMotion.fast,
                    alignment: .centerLeft,
                    child: Text(
                      label,
                      key: ValueKey(label),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.microLabel.copyWith(
                        color: colors.mutedDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                AppLineIconWidget(
                  .chevronR,
                  size: 14,
                  color: colors.chevron,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
