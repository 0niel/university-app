import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppTooltipArrow { up, down }

abstract final class _TooltipMetrics {
  static const double horizontalPadding = AppSpacing.md;
  static const double verticalPadding = AppSpacing.sm;
  static const double screenMargin = AppSpacing.lg;
  static const double gap = AppSpacing.sm;
  static const double tailSize = AppSpacing.gap;
  static const double tailInset = AppSpacing.xxs;
  static const double tailSpace = 7;
}

class AppTooltip extends StatelessWidget {
  const AppTooltip({
    required this.label,
    super.key,
    this.arrow = AppTooltipArrow.down,
  });

  final String label;
  final AppTooltipArrow arrow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final down = arrow == AppTooltipArrow.down;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: down ? AppSpacing.zero : _TooltipMetrics.tailSpace,
            bottom: down ? _TooltipMetrics.tailSpace : AppSpacing.zero,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _TooltipMetrics.horizontalPadding,
              vertical: _TooltipMetrics.verticalPadding,
            ),
            decoration: BoxDecoration(
              color: colors.ink,
              borderRadius: BorderRadius.circular(AppRadius.tooltipBubble),
            ),
            child: Text(
              label,
              style: AppText.subtextStrong.copyWith(color: colors.canvas),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: down ? null : _TooltipMetrics.tailInset,
          bottom: down ? _TooltipMetrics.tailInset : null,
          height: _TooltipMetrics.tailSize,
          child: Center(
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: _TooltipMetrics.tailSize,
                height: _TooltipMetrics.tailSize,
                decoration: BoxDecoration(
                  color: colors.ink,
                  borderRadius: BorderRadius.circular(AppRadius.tooltipTail),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppTooltipAnchor extends StatefulWidget {
  const AppTooltipAnchor({
    required this.message,
    required this.child,
    super.key,
  });

  final String message;
  final Widget child;

  @override
  State<AppTooltipAnchor> createState() => _AppTooltipAnchorState();
}

class _AppTooltipAnchorState extends State<AppTooltipAnchor> {
  final _tooltipKey = GlobalKey<RawTooltipState>();
  bool _below = false;
  double _offset = AppControlSize.touchTarget / 2 + _TooltipMetrics.gap;

  void _prepare() {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final media = MediaQuery.of(context);
    final painter = TextPainter(
      text: TextSpan(text: widget.message, style: AppText.subtextStrong),
      textDirection: Directionality.of(context),
      textScaler: media.textScaler,
    )..layout(
        maxWidth: math.max(
          1,
          media.size.width -
              2 *
                  (_TooltipMetrics.screenMargin +
                      _TooltipMetrics.horizontalPadding),
        ),
      );
    final overlay = Overlay.of(context).context.findRenderObject();
    final top = box.localToGlobal(Offset.zero, ancestor: overlay).dy;
    final below = top - media.padding.top <
        painter.height +
            _TooltipMetrics.verticalPadding * 2 +
            _TooltipMetrics.tailSpace +
            _TooltipMetrics.gap;
    final offset = box.size.height / 2 + _TooltipMetrics.gap;
    painter.dispose();
    if (below != _below || offset != _offset) {
      setState(() {
        _below = below;
        _offset = offset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.isEmpty || !TooltipVisibility.of(context)) {
      return widget.child;
    }
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (focused) {
        if (focused) {
          _prepare();
          _tooltipKey.currentState?.ensureTooltipVisible();
        } else {
          Tooltip.dismissAllToolTips();
        }
      },
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                Tooltip.dismissAllToolTips();
                return null;
              },
            ),
          },
          child: MouseRegion(
            onEnter: (_) => _prepare(),
            child: Listener(
              onPointerDown: (_) => _prepare(),
              child: RawTooltip(
                key: _tooltipKey,
                semanticsTooltip: widget.message,
                ignorePointer: true,
                animationStyle: reduceMotion
                    ? AnimationStyle.noAnimation
                    : const AnimationStyle(
                        duration: Duration(milliseconds: 150),
                        reverseDuration: Duration(milliseconds: 75),
                      ),
                positionDelegate: (position) => positionDependentBox(
                  size: position.overlaySize,
                  childSize: position.tooltipSize,
                  target: position.target,
                  verticalOffset: _offset,
                  preferBelow: _below,
                  margin: _TooltipMetrics.screenMargin,
                ),
                onTriggered: _prepare,
                tooltipBuilder: (context, animation) => FadeTransition(
                  opacity: animation,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: math.max(
                        1,
                        MediaQuery.sizeOf(context).width -
                            _TooltipMetrics.screenMargin * 2,
                      ),
                    ),
                    child: AppTooltip(
                      label: widget.message,
                      arrow: _below ? AppTooltipArrow.up : AppTooltipArrow.down,
                    ),
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
