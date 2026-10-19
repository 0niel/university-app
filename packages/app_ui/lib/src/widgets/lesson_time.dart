part of 'app_lesson_card.dart';

class _LessonTime extends StatelessWidget {
  const _LessonTime({
    required this.start,
    required this.foreground,
    this.end,
    this.horizontal = false,
  });

  final String start;
  final String? end;
  final Color foreground;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final beginning = Text(
      start,
      style: AppText.time.copyWith(color: foreground),
    );
    final ending = end == null
        ? null
        : Text(
            end!,
            style: AppText.timeEnd.copyWith(color: context.colors.muted),
          );
    return horizontal
        ? Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [beginning, ?ending],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [beginning, ?ending],
          );
  }
}

class _LessonBadge extends StatelessWidget {
  const _LessonBadge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final AppLineIcon? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xsm,
      vertical: AppSpacing.micro,
    ),
    decoration: BoxDecoration(
      color: color.withValues(alpha: context.colors.isDark ? .16 : .08),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon case final symbol?) ...[
          AppLineIconWidget(symbol, size: AppIconSize.micro, color: color),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(label, style: AppText.micro.copyWith(color: color)),
        ),
      ],
    ),
  );
}

class _LessonMetadata extends StatelessWidget {
  const _LessonMetadata({
    required this.text,
    required this.icon,
    required this.color,
    this.maxLines,
  });

  final String text;
  final AppLineIcon icon;
  final Color color;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xxs),
        child: AppLineIconWidget(icon, size: AppIconSize.xxs, color: color),
      ),
      const SizedBox(width: AppSpacing.xs),
      Flexible(
        child: Text(
          text,
          maxLines: maxLines,
          overflow: maxLines == null
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: AppText.caption.copyWith(color: color, height: 1.35),
        ),
      ),
    ],
  );
}
