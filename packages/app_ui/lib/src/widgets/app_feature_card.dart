import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppFeatureCard extends StatelessWidget {
  const AppFeatureCard({
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onTap,
    this.semanticsLabel,
    this.tint,
    super.key,
  }) : _identity = false;

  const AppFeatureCard.identity({
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onTap,
    this.semanticsLabel,
    this.tint,
    super.key,
  }) : _identity = true;

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final Color? tint;
  final bool _identity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final labels = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: (_identity ? AppText.identityTitle : AppText.section).copyWith(
            color: colors.ink,
          ),
          maxLines: _identity || largeText ? null : 2,
          overflow: _identity || largeText
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          child: title,
        ),
        if (subtitle case final subtitleWidget?) ...[
          SizedBox(height: _identity ? AppSpacing.gap : AppSpacing.xs),
          DefaultTextStyle(
            style: (_identity ? AppText.body : AppText.cardSubtitle).copyWith(
              color: colors.muted,
            ),
            maxLines: _identity || largeText ? null : 2,
            overflow: _identity || largeText
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            child: subtitleWidget,
          ),
        ],
      ],
    );
    return AppPressable(
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      semanticsButton: onTap != null,
      child: AppGlassSurface(
        tone: AppGlassTone.accent,
        tint: tint,
        borderRadius: _identity ? AppRadius.sheet : AppRadius.lg,
        padding: EdgeInsets.all(
          _identity ? AppSpacing.xlg : AppSpacing.sectionGap,
        ),
        child: _identity
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null || trailing != null) ...[
                    Row(
                      children: [
                        ?leading,
                        const Spacer(),
                        ?trailing,
                      ],
                    ),
                    const SizedBox(height: AppSpacing.contentGap),
                  ],
                  labels,
                ],
              )
            : Row(
                children: [
                  if (leading case final leadingWidget?) ...[
                    leadingWidget,
                    const SizedBox(width: AppSpacing.gap),
                  ],
                  Expanded(child: labels),
                  if (trailing case final trailingWidget?) ...[
                    const SizedBox(width: AppSpacing.sm),
                    trailingWidget,
                  ],
                ],
              ),
      ),
    );
  }
}
