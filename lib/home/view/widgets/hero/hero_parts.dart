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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: background ?? context.colors.surface,
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
  const HeroTimeColumn({required this.start, required this.end, super.key});
  final String start;
  final String end;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 44),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(start, style: AppText.time.copyWith(color: context.colors.ink)),
        Text(end, style: AppText.timeEnd.copyWith(color: context.colors.muted)),
      ],
    ),
  );
}

class HeroSubject extends StatelessWidget {
  const HeroSubject({
    required this.subject,
    required this.meta,
    super.key,
    this.size = 22,
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
        AppBalancedText(
          subject,
          style: AppText.serif(
            size,
            height: height,
          ).copyWith(color: context.colors.ink),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            meta,
            style: AppText.sans(
              13,
              FontWeight.w400,
              height: 17 / 13,
            ).copyWith(color: context.colors.muted),
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
    children: [
      Expanded(
        child: AppButton.secondary(
          label: context.l10n.lessonDetailsRoute,
          icon: const AppLineIconWidget(AppLineIcon.pin, size: 16),
          size: AppButtonSize.small,
          textStyle: AppText.compactStrong,
          backgroundColor: context.colors.surface,
          expanded: true,
          onPressed: onRoute,
        ),
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
