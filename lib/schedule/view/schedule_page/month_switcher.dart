part of '../schedule_page.dart';

class _MonthSwitcher extends StatelessWidget {
  const _MonthSwitcher({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final locale = Localizations.localeOf(context).toString();
    final title = capitalizeFirst(
      DateFormat('LLLL yyyy', locale).format(month),
    );
    return Padding(
      padding: const .symmetric(vertical: 3),
      child: Row(
        children: [
          NinjaIconButton(
            icon: AppLineIconWidget(
              AppLineIcon.chevronL,
              size: 18,
              color: colors.ink,
            ),
            tooltip: context.l10n.previousMonth,
            onPressed: onPrev,
          ),
          Expanded(
            child: NinjaStateSwitcher(
              alignment: .center,
              child: Text(
                title,
                key: ValueKey(title),
                textAlign: .center,
                style: NinjaText.headline.copyWith(color: colors.ink),
              ),
            ),
          ),
          NinjaIconButton(
            icon: AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 18,
              color: colors.ink,
            ),
            tooltip: context.l10n.nextMonth,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
