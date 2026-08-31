part of '../schedule_page.dart';

class _ScheduleEmptyBlock extends StatelessWidget {
  const _ScheduleEmptyBlock({
    required this.title,
    required this.message,
    this.actions = const <Widget>[],
    this.dashed = false,
  });

  final String title;
  final String message;

  final List<Widget> actions;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final background = colors.surface;
    final foreground = colors.ink;
    final muted = colors.mutedDark;
    final copy = Expanded(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            maxLines: scale > 1.3 ? 3 : 2,
            overflow: .ellipsis,
            style: NinjaText.dialogTitle.copyWith(color: foreground),
          ),
          const SizedBox(height: 3),
          Text(
            message,
            maxLines: scale > 1.3 ? 4 : 2,
            overflow: .ellipsis,
            style: NinjaText.subtext.copyWith(color: muted),
          ),
        ],
      ),
    );
    final focal = ExcludeSemantics(
      child: Container(
        width: 52,
        height: 52,
        alignment: .center,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          shape: .circle,
        ),
        child: AppLineIconWidget(
          dashed ? .search : .spark,
          size: 24,
          color: colors.brandInk,
        ),
      ),
    );
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        6,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Row(children: [focal, const SizedBox(width: 13), copy]),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 12),
                if (scale > 1.35)
                  Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      for (final (index, action) in actions.indexed) ...[
                        action,
                        if (index != actions.length - 1)
                          const SizedBox(height: 8),
                      ],
                    ],
                  )
                else
                  Row(
                    children: [
                      for (final (index, action) in actions.indexed) ...[
                        Expanded(child: action),
                        if (index != actions.length - 1)
                          const SizedBox(width: 8),
                      ],
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
