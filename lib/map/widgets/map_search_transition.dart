import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MapSearchTransition extends StatelessWidget {
  const MapSearchTransition({
    required this.animation,
    required this.searching,
    required this.height,
    required this.search,
    required this.actions,
    required this.tooltip,
    required this.onToggle,
    super.key,
  });

  final Animation<double> animation;
  final bool searching;
  final double height;
  final Widget search;
  final Widget actions;
  final String tooltip;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const collapsedExtent = 50.0;
      final width = constraints.maxWidth;
      return SizedBox(
        height: height,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final progress = animation.value;
            final actionsOpacity =
                1 - const Interval(0, .4).transform(progress);
            final searchOpacity = const Interval(.3, 1).transform(progress);
            final expanded = searching && animation.isCompleted;
            return Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                if (!animation.isCompleted)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: collapsedExtent + AppSpacing.sm,
                    ),
                    child: ExcludeFocus(
                      excluding: searching || !animation.isDismissed,
                      child: ExcludeSemantics(
                        excluding: searching || !animation.isDismissed,
                        child: IgnorePointer(
                          ignoring: searching || !animation.isDismissed,
                          child: Opacity(
                            opacity: actionsOpacity,
                            child: actions,
                          ),
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: SizedBox(
                      width: lerpDouble(collapsedExtent, width, progress),
                      height: lerpDouble(collapsedExtent, height, progress),
                      child: ColoredBox(
                        color: context.colors.surface,
                        child: OverflowBox(
                          alignment: AlignmentDirectional.centerStart,
                          minWidth: width,
                          maxWidth: width,
                          minHeight: height,
                          maxHeight: height,
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              if (!animation.isDismissed || searching)
                                ExcludeFocus(
                                  excluding: !expanded,
                                  child: ExcludeSemantics(
                                    excluding: !expanded,
                                    child: IgnorePointer(
                                      ignoring: !expanded,
                                      child: Opacity(
                                        opacity: searchOpacity,
                                        child: search,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width: collapsedExtent,
                                height: height,
                                child: Center(
                                  child: AppIconButton(
                                    tooltip: tooltip,
                                    tone: AppIconButtonTone.surface,
                                    shape: AppIconButtonShape.circle,
                                    onPressed: onToggle,
                                    icon: SizedBox.square(
                                      dimension: AppIconSize.md,
                                      child: Stack(
                                        children: [
                                          Opacity(
                                            opacity: actionsOpacity,
                                            child: const AppLineIconWidget(
                                              AppLineIcon.search,
                                            ),
                                          ),
                                          Opacity(
                                            opacity: const Interval(
                                              .4,
                                              1,
                                            ).transform(progress),
                                            child: const AppLineIconWidget(
                                              AppLineIcon.chevronL,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
