import 'dart:async';

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_filter_chip.dart';
import 'package:app_ui/src/widgets/app_horizontal_scroll_view.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppChipRow<T> extends StatefulWidget {
  const AppChipRow({
    required this.items,
    required this.value,
    super.key,
    this.onChanged,
    this.padding = EdgeInsets.zero,
    this.spacing = AppSpacing.xsm,
    this.controller,
    this.style = AppChipStyle.filter,
  });

  final List<AppChipRowItem<T>> items;
  final T value;
  final ValueChanged<T>? onChanged;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final ScrollController? controller;
  final AppChipStyle style;

  @override
  State<AppChipRow<T>> createState() => _AppChipRowState<T>();
}

class _AppChipRowState<T> extends State<AppChipRow<T>> {
  final _keys = <T, GlobalKey>{};
  bool _revealPending = false;
  (double, TextScaler)? _layoutMetrics;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleReveal();
  }

  @override
  void didUpdateWidget(AppChipRow<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _keys.removeWhere(
      (value, _) => !widget.items.any((item) => item.value == value),
    );
    if (oldWidget.value != widget.value ||
        oldWidget.controller != widget.controller ||
        oldWidget.items.length != widget.items.length ||
        oldWidget.style != widget.style ||
        oldWidget.padding != widget.padding ||
        oldWidget.spacing != widget.spacing ||
        widget.items.indexed.any(
          (entry) =>
              entry.$2.value !=
                  oldWidget.items.elementAtOrNull(entry.$1)?.value ||
              entry.$2.label !=
                  oldWidget.items.elementAtOrNull(entry.$1)?.label ||
              entry.$2.count !=
                  oldWidget.items.elementAtOrNull(entry.$1)?.count ||
              entry.$2.icon != oldWidget.items.elementAtOrNull(entry.$1)?.icon,
        )) {
      _scheduleReveal();
    }
  }

  void _scheduleReveal() {
    if (_revealPending) return;
    _revealPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revealPending = false;
      if (!mounted) return;
      final targetContext = _keys[widget.value]?.currentContext;
      final target = targetContext?.findRenderObject();
      if (targetContext == null || target == null) return;
      final scrollable = Scrollable.maybeOf(
        targetContext,
        axis: Axis.horizontal,
      );
      final viewport = RenderAbstractViewport.maybeOf(target);
      if (scrollable == null || viewport == null) return;
      final position = scrollable.position;
      if (!position.hasContentDimensions) return;
      final index = widget.items.indexWhere(
        (item) => item.value == widget.value,
      );
      if (index < 0) return;
      final padding = widget.padding.resolve(Directionality.of(context));
      final reversed = position.axisDirection == AxisDirection.left;
      final leading =
          viewport.getOffsetToReveal(target, 0).offset -
          (reversed ? padding.right : padding.left);
      final trailing =
          viewport.getOffsetToReveal(target, 1).offset +
          (reversed ? padding.left : padding.right);
      final offset = switch (index) {
        0 => position.minScrollExtent,
        _ when index == widget.items.length - 1 => position.maxScrollExtent,
        _
            when target.paintBounds.width >
                position.viewportDimension - padding.horizontal =>
          leading,
        _ when position.pixels > leading + .5 => leading,
        _ when position.pixels < trailing - .5 => trailing,
        _ => position.pixels,
      }.clamp(position.minScrollExtent, position.maxScrollExtent);
      if ((position.pixels - offset).abs() < .5) return;
      final duration = NinjaMotion.of(context);
      if (duration == Duration.zero) {
        position.jumpTo(offset);
      } else {
        unawaited(
          position.animateTo(
            offset,
            duration: duration,
            curve: NinjaMotion.enter,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = (
          constraints.maxWidth,
          MediaQuery.textScalerOf(context),
        );
        if (_layoutMetrics != metrics) {
          _layoutMetrics = metrics;
          _scheduleReveal();
        }
        return AppHorizontalScrollView(
          padding: widget.padding,
          controller: widget.controller,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (index, item) in widget.items.indexed) ...[
                if (index > 0) SizedBox(width: widget.spacing),
                KeyedSubtree(
                  key: _keys.putIfAbsent(item.value, GlobalKey.new),
                  child: widget.style == AppChipStyle.filter
                      ? AppChip.filter(
                          key: item.key ?? ValueKey(item.value),
                          label: item.label,
                          leadingIcon: item.icon,
                          count: item.count,
                          selected: item.value == widget.value,
                          onTap: widget.onChanged == null
                              ? null
                              : () => widget.onChanged?.call(item.value),
                        )
                      : AppChip(
                          key: item.key ?? ValueKey(item.value),
                          label: item.label,
                          leadingIcon: item.icon,
                          count: item.count,
                          selected: item.value == widget.value,
                          onTap: widget.onChanged == null
                              ? null
                              : () => widget.onChanged?.call(item.value),
                        ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class AppChipRowItem<T> {
  const AppChipRowItem({
    required this.value,
    required this.label,
    this.icon,
    this.count,
    this.key,
  });

  final T value;
  final String label;
  final AppLineIcon? icon;
  final int? count;
  final Key? key;
}
