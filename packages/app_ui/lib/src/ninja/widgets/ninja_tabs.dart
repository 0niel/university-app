import 'dart:async';

import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NinjaTabs<T> extends StatefulWidget {
  const NinjaTabs({
    required this.tabs,
    required this.value,
    super.key,
    this.onChanged,
    this.padding = const EdgeInsets.symmetric(
      horizontal: NinjaMetrics.screenPadding,
    ),
    this.spacing = 8,
  });

  final List<NinjaTab<T>> tabs;
  final T value;
  final ValueChanged<T>? onChanged;
  final EdgeInsetsGeometry padding;
  final double spacing;

  @override
  State<NinjaTabs<T>> createState() => _NinjaTabsState<T>();
}

class _NinjaTabsState<T> extends State<NinjaTabs<T>> {
  final Map<T, GlobalKey> _tabKeys = {};
  final ScrollController _scrollController = ScrollController();
  bool _revealScheduled = false;

  @override
  void initState() {
    super.initState();
    _scheduleReveal();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleReveal();
  }

  @override
  void didUpdateWidget(covariant NinjaTabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tabKeys.removeWhere(
      (value, _) => !widget.tabs.any((tab) => tab.value == value),
    );
    if (oldWidget.value != widget.value ||
        !listEquals(oldWidget.tabs, widget.tabs)) {
      _scheduleReveal();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleReveal() {
    if (_revealScheduled) return;
    _revealScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revealScheduled = false;
      if (!mounted) return;
      final target = _tabKeys[widget.value]?.currentContext?.findRenderObject();
      if (target == null || !_scrollController.hasClients) {
        return;
      }
      final position = _scrollController.position;
      final viewport = RenderAbstractViewport.maybeOf(target);
      if (viewport == null) return;
      final offset = viewport
          .getOffsetToReveal(target, 0.5)
          .offset
          .clamp(position.minScrollExtent, position.maxScrollExtent);
      if ((offset - _scrollController.offset).abs() < 0.5) return;
      final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
          MediaQuery.accessibleNavigationOf(context);
      if (reduceMotion) {
        _scrollController.jumpTo(offset);
      } else {
        unawaited(
          _scrollController.animateTo(
            offset,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          padding: widget.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (index, tab) in widget.tabs.indexed) ...[
                if (index > 0) SizedBox(width: widget.spacing),
                _NinjaTabItem(
                  key: _tabKeys.putIfAbsent(
                    tab.value,
                    GlobalKey.new,
                  ),
                  tab: tab,
                  colors: colors,
                  selected: tab.value == widget.value,
                  maxWidth: constraints.maxWidth,
                  onTap: widget.onChanged == null
                      ? null
                      : () => widget.onChanged?.call(tab.value),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class NinjaTab<T> {
  const NinjaTab({required this.value, required this.label, this.count});

  final T value;
  final String label;
  final int? count;
}

class _NinjaTabItem<T> extends StatelessWidget {
  const _NinjaTabItem({
    required this.tab,
    required this.colors,
    required this.selected,
    required this.maxWidth,
    required this.onTap,
    super.key,
  });

  final NinjaTab<T> tab;
  final NinjaColors colors;
  final bool selected;
  final double maxWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final count = tab.count;
    final maxLabelWidth = (maxWidth - (count == null ? 72 : 116))
        .clamp(64, double.infinity)
        .toDouble();
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      child: AppPressable(
        haptics: !selected,
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(
            minHeight: NinjaMetrics.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colors.ink : colors.surfaceAlt,
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: Curves.easeOutCubic,
                style: NinjaText.button.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? colors.onInk : colors.mutedDark,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxLabelWidth,
                  ),
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 7),
                _NinjaTabBadge(
                  count: count,
                  background: colors.surface,
                  foreground: colors.mutedDark,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NinjaTabBadge extends StatelessWidget {
  const _NinjaTabBadge({
    required this.count,
    required this.background,
    required this.foreground,
  });

  final int count;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(NinjaRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          '$count',
          style: NinjaText.badge.copyWith(
            letterSpacing: 0,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
