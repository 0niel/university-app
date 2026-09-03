import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';

class AppSmartChip extends StatelessWidget {
  const AppSmartChip({
    required this.emoji,
    required this.label,
    required this.value,
    required this.tone,
    super.key,
  }) : icon = null;

  const AppSmartChip.icon({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
    super.key,
  }) : emoji = null;

  final String? emoji;
  final Widget? icon;
  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      label: '$label, $value',
      child: ExcludeSemantics(
        child: Container(
          constraints: const BoxConstraints(minHeight: AppControlSize.field),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.chipInset,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.field),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 30,
                decoration: BoxDecoration(
                  color: tone,
                  borderRadius: BorderRadius.circular(AppRadius.xxs),
                ),
              ),
              const SizedBox(width: AppSpacing.badgeInset),
              icon ??
                  Text(
                    emoji ?? '',
                    style: const TextStyle(fontSize: 20, height: 1),
                  ),
              const SizedBox(width: AppSpacing.gap),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: colors.muted),
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyStrong.copyWith(color: colors.ink),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
