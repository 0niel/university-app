import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    required this.title,
    super.key,
    this.subtitle,
    this.action,
    this.onActionTap,
    this.meta,
    this.topMargin = AppSpacing.section,
    this.bottomPadding = AppSpacing.md,
  });

  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onActionTap;
  final String? meta;
  final double topMargin;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    final actionText = action;
    final metaText = meta;
    final titleStyle =
        AppText.serif(22, height: 1.5).copyWith(color: colors.ink);
    final actionStyle = AppText.label.copyWith(color: colors.accent);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maximumActionWidth = constraints.maxWidth / 3;
        final actionSize = actionText == null
            ? null
            : _measure(
                context,
                actionText,
                actionStyle,
                math.max(0, maximumActionWidth - AppSpacing.md),
                maxLines: 2,
              );
        final actionWidth = actionSize == null
            ? 0.0
            : math.min(
                maximumActionWidth,
                math.max(
                  AppControlSize.touchTarget,
                  actionSize.width + AppSpacing.md,
                ),
              );
        final titleSize = actionSize == null
            ? null
            : _measure(
                context,
                title,
                titleStyle,
                constraints.maxWidth - actionWidth,
              );
        return Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: actionText == null ? 0 : AppControlSize.touchTarget,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: topMargin,
                  bottom: bottomPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(title, style: titleStyle),
                          if (subtitleText != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              subtitleText,
                              style: AppText.subtext.copyWith(
                                color: colors.muted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (actionSize != null)
                      Baseline(
                        baseline: actionSize.baseline,
                        baselineType: TextBaseline.alphabetic,
                        child: SizedBox(
                          width: actionWidth,
                          height: actionSize.height,
                        ),
                      )
                    else if (metaText != null)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth / 2,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: AppSpacing.md,
                          ),
                          child: Text(
                            metaText,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: AppText.sans(
                              13,
                              FontWeight.w500,
                            ).copyWith(color: colors.muted),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (actionSize != null && titleSize != null)
              PositionedDirectional(
                top: 0,
                bottom: 0,
                end: 0,
                width: actionWidth,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final height = math.min(
                      constraints.maxHeight,
                      math.max(AppControlSize.touchTarget, actionSize.height),
                    );
                    final visualTop = topMargin +
                        math.max(titleSize.baseline, actionSize.baseline) -
                        actionSize.baseline;
                    final top = (visualTop + (actionSize.height - height) / 2)
                        .clamp(0.0, constraints.maxHeight - height);
                    return Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: top,
                          height: height,
                          child: AppPressable(
                            onTap: onActionTap,
                            enabled: onActionTap != null,
                            semanticsLabel: actionText,
                            semanticsButton: true,
                            child: Stack(
                              children: [
                                PositionedDirectional(
                                  top: visualTop - top,
                                  start: AppSpacing.md,
                                  end: 0,
                                  height: actionSize.height,
                                  child: Text(
                                    actionText!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: actionStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

({double width, double height, double baseline}) _measure(
  BuildContext context,
  String text,
  TextStyle style,
  double width, {
  int? maxLines,
}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
    locale: Localizations.maybeLocaleOf(context),
    maxLines: maxLines,
    ellipsis: maxLines == null ? null : '…',
  )..layout(maxWidth: width);
  final result = (
    width: painter.width,
    height: painter.height,
    baseline: painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
  );
  painter.dispose();
  return result;
}
