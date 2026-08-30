part of '../schedule_page.dart';

class _ScheduleChrome extends StatelessWidget {
  const _ScheduleChrome({
    required this.scheduleName,
    required this.onSearch,
    required this.onMore,
  });

  final String scheduleName;
  final VoidCallback onSearch;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = MediaQuery.textScalerOf(
      context,
    ).scale(1).clamp(1, 2).toDouble();

    return ColoredBox(
      color: colors.canvas,
      child: Padding(
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          6,
          NinjaMetrics.screenPadding,
          4,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 56 + (scale - 1) * 26),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      context.l10n.scheduleAppBarTitle,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scheduleName,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.helper.copyWith(
                        color: colors.mutedDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              NinjaIconButton(
                icon: AppLineIconWidget(
                  AppLineIcon.search,
                  size: 20,
                  color: colors.ink,
                ),
                tooltip: context.l10n.search,
                onPressed: onSearch,
              ),
              const SizedBox(width: 8),
              NinjaIconButton(
                icon: AppLineIconWidget(
                  AppLineIcon.more,
                  size: 20,
                  color: colors.ink,
                ),
                tooltip: context.l10n.more,
                onPressed: onMore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
