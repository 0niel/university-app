part of '../schedule_page.dart';

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final UserActivity activity;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final end = activity.endsAt;
    final time = [
      DateFormat('HH:mm').format(activity.startsAt),
      if (end != null) DateFormat('HH:mm').format(end),
    ].join('–');
    final meta = [?activity.place, ?activity.subtitle].join(' · ');

    final tone = _activityColor(colors, activity.type);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final timeWidth = 54.0 + ((scale - 1).clamp(0, 1) * 24).toDouble();
    return Semantics(
      label: '${activity.title}, $time${meta.isEmpty ? '' : ', $meta'}',
      child: Padding(
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          0,
          NinjaMetrics.screenPadding,
          5,
        ),
        child: Container(
          padding: const .fromLTRB(12, 11, 12, 12),
          decoration: BoxDecoration(
            color: tone.withValues(alpha: colors.isDark ? .1 : .06),
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: timeWidth,
                child: Text(
                  time,
                  maxLines: 2,
                  style: NinjaText.tabular(
                    NinjaText.body.copyWith(color: colors.mutedDark),
                  ),
                ),
              ),
              Container(
                width: 4,
                height: 42,
                decoration: BoxDecoration(
                  color: tone,
                  borderRadius: .circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      activity.title,
                      maxLines: 3,
                      overflow: .ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        meta,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: NinjaText.subtext.copyWith(
                          color: colors.mutedDark,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
