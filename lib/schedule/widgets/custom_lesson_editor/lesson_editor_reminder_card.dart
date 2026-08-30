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
    final colors = context.ninja;
    final subtitle = leadLabel;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      clipBehavior: .antiAlias,
      child: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            AppLineIconWidget(.bell, size: 20, color: colors.mutedDark),
            const SizedBox(width: 12),
            Expanded(
              child: AppPressable(
                onTap: onTapLead,
                semanticsLabel: [title, ?subtitle].join(', '),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: NinjaMetrics.minTouchTarget,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          title,
                          style: NinjaText.body.copyWith(
                            color: colors.ink,
                            fontWeight: .w600,
                          ),
                        ),
                        if (enabled && subtitle != null)
                          Text(
                            subtitle,
                            style: NinjaText.helper.copyWith(
                              color: colors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            NinjaSwitch(value: enabled, onChanged: onToggle),
          ],
        ),
      ),
    );
  }
}
