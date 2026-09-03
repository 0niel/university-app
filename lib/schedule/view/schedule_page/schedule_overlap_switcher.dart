import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ScheduleOverlapSwitcher extends StatefulWidget {
  const ScheduleOverlapSwitcher({
    required this.children,
    required this.labels,
    required this.colors,
    this.compact = false,
    this.initialIndex = 0,
    super.key,
  }) : assert(children.length == labels.length, 'Every lesson needs a label'),
       assert(children.length == colors.length, 'Every lesson needs a color');

  final List<Widget> children;
  final List<String> labels;
  final List<Color> colors;
  final bool compact;
  final int initialIndex;

  @override
  State<ScheduleOverlapSwitcher> createState() =>
      _ScheduleOverlapSwitcherState();
}

class _ScheduleOverlapSwitcherState extends State<ScheduleOverlapSwitcher> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox.shrink();
    if (widget.children.length == 1) return widget.children.single;
    final index = _index.clamp(0, widget.children.length - 1);
    final next = (index + 1) % widget.children.length;
    final label = context.l10n.scheduleSimultaneousLessons(
      widget.children.length,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: widget.colors[index], width: 1.5),
        borderRadius: BorderRadius.circular(
          widget.compact ? AppRadius.sm : AppRadius.card,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPressable(
            key: const ValueKey('schedule-overlap-next'),
            semanticsLabel:
                '$label, ${index + 1}/${widget.children.length}, '
                '${widget.labels[next]}',
            onTap: () => setState(() => _index = next),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppControlSize.touchTarget,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? AppSpacing.xs : AppSpacing.md,
                vertical: AppSpacing.xsm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!widget.compact) ...[
                        Expanded(
                          child: Text(
                            label,
                            style: AppText.captionSmall.copyWith(
                              color: context.colors.muted,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Flexible(
                        child: Text(
                          '${index + 1}/${widget.children.length}',
                          style: AppText.sans(10, FontWeight.w700).copyWith(
                            color: widget.colors[index],
                          ),
                        ),
                      ),
                      AppLineIconWidget(
                        AppLineIcon.chevronR,
                        size: 12,
                        color: widget.colors[index],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xxs,
                    children: [
                      for (var i = 0; i < widget.colors.length; i++)
                        Container(
                          key: ValueKey('schedule-overlap-marker-$i'),
                          width: i == index ? 12 : 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: widget.colors[i],
                            borderRadius: BorderRadius.circular(AppRadius.xxs),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          widget.children[index],
        ],
      ),
    );
  }
}
