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
  double _dragDistance = 0;

  @override
  void didUpdateWidget(covariant ScheduleOverlapSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.isEmpty) {
      _index = 0;
      return;
    }
    final previous = oldWidget.labels.elementAtOrNull(_index);
    if (previous != null && widget.labels.elementAtOrNull(_index) == previous) {
      return;
    }
    final retained = previous == null ? -1 : widget.labels.indexOf(previous);
    _index = retained >= 0
        ? retained
        : widget.initialIndex.clamp(0, widget.children.length - 1);
  }

  void _select(int index) {
    setState(() => _index = index % widget.children.length);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox.shrink();
    if (widget.children.length == 1) return widget.children.single;
    final index = _index.clamp(0, widget.children.length - 1);
    final next = (index + 1) % widget.children.length;
    final label = context.l10n.scheduleSimultaneousLessons(
      widget.children.length,
    );
    final duration = NinjaMotion.of(context);
    final radius = widget.compact ? AppRadius.sm : AppRadius.card;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final content = KeyedSubtree(
      key: ValueKey('${widget.labels[index]}-$index'),
      child: widget.children[index],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AppCard(
        key: const ValueKey('schedule-overlap-card'),
        padding: EdgeInsets.zero,
        radius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppPressable(
              key: const ValueKey('schedule-overlap-next'),
              semanticsLabel:
                  '$label, ${index + 1}/${widget.children.length}, '
                  '${widget.labels[next]}',
              onTap: () => _select(next),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppControlSize.touchTarget,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widget.compact ? AppSpacing.xs : AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
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
                      flex: widget.compact ? 1 : 0,
                      child: Text(
                        '${index + 1}/${widget.children.length}',
                        style: AppText.sans(
                          widget.compact ? 10 : 12,
                          FontWeight.w700,
                        ).copyWith(color: context.colors.accent),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    AppLineIconWidget(
                      rtl ? AppLineIcon.chevronL : AppLineIcon.chevronR,
                      size: 12,
                      color: context.colors.accent,
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 1, color: context.colors.line),
            GestureDetector(
              key: const ValueKey('schedule-overlap-content'),
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: (_) => _dragDistance = 0,
              onHorizontalDragUpdate: (details) =>
                  _dragDistance += details.primaryDelta ?? 0,
              onHorizontalDragEnd: (details) {
                final velocity = details.primaryVelocity ?? 0;
                if (_dragDistance.abs() < 36 && velocity.abs() < 250) return;
                final direction = _dragDistance.abs() >= 36
                    ? _dragDistance
                    : velocity;
                final forward = rtl ? direction > 0 : direction < 0;
                _select(index + (forward ? 1 : -1));
              },
              child: duration == Duration.zero
                  ? content
                  : AnimatedSize(
                      duration: duration,
                      curve: NinjaMotion.enter,
                      alignment: Alignment.topCenter,
                      child: AnimatedSwitcher(
                        duration: duration,
                        switchInCurve: NinjaMotion.enter,
                        switchOutCurve: NinjaMotion.exit,
                        layoutBuilder: (current, previous) => Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            for (final child in previous)
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                child: IgnorePointer(
                                  child: ExcludeSemantics(child: child),
                                ),
                              ),
                            ?current,
                          ],
                        ),
                        child: content,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
