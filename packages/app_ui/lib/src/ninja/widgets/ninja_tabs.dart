import 'dart:async';

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NinjaTabs<T> extends StatefulWidget {
  const NinjaTabs({
    required this.tabs,
    required this.value,
    super.key,
    this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    this.spacing = AppSpacing.contentGap,
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
      if (target == null || !_scrollController.hasClients) return;
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
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: widget.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final (index, tab) in widget.tabs.indexed) ...[
              if (index > 0) SizedBox(width: widget.spacing),
              _NinjaTabItem<T>(
                key: _tabKeys.putIfAbsent(tab.value, GlobalKey.new),
                tab: tab,
                selected: tab.value == widget.value,
                onTap: widget.onChanged == null
                    ? null
                    : () => widget.onChanged?.call(tab.value),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NinjaTab<T> {
  const NinjaTab({required this.value, required this.label, this.count});

  final T value;
  final String label;
  final int? count;
}

typedef AppTabs<T> = NinjaTabs<T>;

typedef AppTab<T> = NinjaTab<T>;

class _NinjaTabItem<T> extends StatelessWidget {
  const _NinjaTabItem({
    required this.tab,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final NinjaTab<T> tab;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = tab.count;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 200);

    return AppPressState(
      onTap: onTap,
      enabled: onTap != null,
      haptics: !selected,
      semanticsLabel: tab.label,
      semanticsButton: true,
      semanticsSelected: selected,
      builder: (context, {required pressed}) => Transform.translate(
        offset: const Offset(0, 1),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppControlSize.touchTarget,
            minWidth: AppControlSize.touchTarget,
          ),
          padding:
              const EdgeInsets.only(top: AppSpacing.gap, bottom: AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? colors.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: Curves.easeOut,
                style: AppText.tab.copyWith(
                  color: selected ? colors.ink : colors.muted,
                ),
                child:
                    Text(tab.label, maxLines: 1, overflow: TextOverflow.fade),
              ),
              if (count != null) ...[
                const SizedBox(width: AppSpacing.xsm),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.compactGap,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      '$count',
                      style: AppText.sans(11, FontWeight.w600).copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
