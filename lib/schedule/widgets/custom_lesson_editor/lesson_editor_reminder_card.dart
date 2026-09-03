import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class LessonEditorReminderCard extends StatelessWidget {
  const LessonEditorReminderCard({
    required this.title,
    required this.enabled,
    required this.onToggle,
    this.leadLabel,
    this.onTapLead,
    super.key,
  });

  final String title;
  final bool enabled;
  final String? leadLabel;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTapLead;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = leadLabel;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      clipBehavior: .antiAlias,
      child: Padding(
        padding: const .symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.gap,
        ),
        child: Row(
          children: [
            AppLineIconWidget(.bell, size: 20, color: colors.muted),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppPressable(
                onTap: onTapLead,
                semanticsLabel: [title, ?subtitle].join(', '),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppControlSize.touchTarget,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          title,
                          style: AppText.body.copyWith(
                            color: colors.ink,
                            fontWeight: .w600,
                          ),
                        ),
                        if (enabled && subtitle != null)
                          Text(
                            subtitle,
                            style: AppText.captionSmall.copyWith(
                              color: colors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.gap),
            AppSwitch(value: enabled, onChanged: onToggle),
          ],
        ),
      ),
    );
  }
}
