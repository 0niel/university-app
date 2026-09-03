import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppDeadlineRow extends StatelessWidget {
  const AppDeadlineRow({
    required this.title,
    required this.meta,
    required this.left,
    super.key,
    this.urgent = false,
    this.done = false,
    this.onTap,
    this.onToggle,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.gap,
      AppSpacing.gap,
      AppSpacing.lg,
      AppSpacing.gap,
    ),
  });

  final String title;
  final String meta;
  final String left;
  final bool urgent;
  final bool done;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final leftColor =
        done ? colors.muted2 : (urgent ? colors.danger : colors.muted);

    final row = AnimatedOpacity(
      opacity: done ? .55 : 1,
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            AppDeadlineCheck(
              done: done,
              onTap: onToggle,
              semanticsLabel: title,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cell.copyWith(
                      color: colors.ink,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: colors.muted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.gap),
            Text(
              left,
              style: AppText.sans(12, FontWeight.w800).copyWith(
                color: leftColor,
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return row;
    return AppPressable(onTap: onTap, semanticsButton: true, child: row);
  }
}

class AppDeadlineCheck extends StatelessWidget {
  const AppDeadlineCheck({
    required this.done,
    super.key,
    this.onTap,
    this.semanticsLabel,
  });

  final bool done;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    final circle = AnimatedContainer(
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: AppControlSize.iconButton,
      height: AppControlSize.iconButton,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: done ? colors.accent : colors.surface2,
        shape: BoxShape.circle,
      ),
      child: AppLineIconWidget(
        AppLineIcon.check,
        size: AppIconSize.compact,
        strokeWidth: 2.4,
        color: done ? colors.onAccent : colors.muted,
      ),
    );

    if (onTap == null) return circle;

    return AppPressable(
      onTap: onTap,
      semanticsToggled: done,
      semanticsLabel: semanticsLabel,
      child: circle,
    );
  }
}

class AppDeadlineCard extends StatelessWidget {
  const AppDeadlineCard({
    required this.subject,
    required this.task,
    required this.due,
    required this.left,
    required this.progress,
    super.key,
    this.urgent = false,
    this.done = false,
    this.onTap,
    this.onToggle,
  });

  final String subject;
  final String task;
  final String due;
  final String left;
  final double progress;
  final bool urgent;
  final bool done;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: AppDeadlineRow(
        title: task,
        meta: '$subject · $due',
        left: left,
        urgent: urgent,
        done: done,
        onToggle: onToggle,
      ),
    );
  }
}
