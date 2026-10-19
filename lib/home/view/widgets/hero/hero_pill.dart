import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroPill extends StatelessWidget {
  const HeroPill({
    required this.label,
    super.key,
    this.leading,
    this.background,
    this.foreground,
  });

  final String label;
  final Widget? leading;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background ?? context.colors.accent.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 7)],
        Flexible(
          child: Text(
            label,
            style: AppText.captionBold.copyWith(
              color: foreground ?? context.colors.accent,
              height: 16 / 12,
            ),
          ),
        ),
      ],
    ),
  );
}

class HeroMeta extends StatelessWidget {
  const HeroMeta(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppText.label.copyWith(color: context.colors.muted, height: 17 / 13),
  );
}

class HeroTimeColumn extends StatelessWidget {
  const HeroTimeColumn({
    required this.start,
    required this.end,
    this.horizontal = false,
    super.key,
  });
  final String start;
  final String end;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final times = [
      Text(
        start,
        style: AppText.metric.copyWith(color: context.colors.ink),
      ),
      Text(end, style: AppText.timeEnd.copyWith(color: context.colors.muted)),
    ];
    return horizontal
        ? Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: times,
          )
        : ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: times,
            ),
          );
  }
}

class HeroSubject extends StatelessWidget {
  const HeroSubject({
    required this.subject,
    required this.meta,
    super.key,
    this.size = 20,
    this.height = 1.15,
    this.onTap,
  });
  final String subject;
  final String meta;
  final double size;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: onTap,
    semanticsLabel: subject,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          subject,
          maxLines: MediaQuery.textScalerOf(context).scale(1) > 1.4 ? null : 2,
          overflow: MediaQuery.textScalerOf(context).scale(1) > 1.4
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: AppText.sans(
            size,
            FontWeight.w700,
            height: height,
          ).copyWith(color: context.colors.ink, letterSpacing: -.7),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            meta,
            style: AppText.caption.copyWith(
              color: context.colors.muted,
              height: 1.35,
            ),
          ),
        ],
      ],
    ),
  );
}

class HeroActions extends StatelessWidget {
  const HeroActions({required this.onRoute, required this.onNote, super.key});
  final VoidCallback? onRoute;
  final VoidCallback onNote;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppIconButton(
        icon: const AppLineIconWidget(AppLineIcon.pin, size: 18),
        tone: AppIconButtonTone.surface,
        shape: AppIconButtonShape.circle,
        tooltip: context.l10n.lessonDetailsRoute,
        onPressed: onRoute,
      ),
      const SizedBox(width: 8),
      AppIconButton(
        icon: const AppLineIconWidget(AppLineIcon.pencil, size: 18),
        tone: AppIconButtonTone.surface,
        shape: AppIconButtonShape.circle,
        tooltip: context.l10n.lessonDetailsNote,
        onPressed: onNote,
      ),
    ],
  );
}

class HeroLessonHeader extends StatelessWidget {
  const HeroLessonHeader({
    required this.status,
    required this.detail,
    required this.onRoute,
    required this.onNote,
    super.key,
  });

  final Widget status;
  final String detail;
  final VoidCallback? onRoute;
  final VoidCallback onNote;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [status, HeroMeta(detail)],
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      HeroActions(onRoute: onRoute, onNote: onNote),
    ],
  );
}
