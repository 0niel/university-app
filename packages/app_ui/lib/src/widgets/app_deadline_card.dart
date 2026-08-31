import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppDeadlineCard extends StatelessWidget {
  const AppDeadlineCard({
    required this.subject,
    required this.task,
    required this.due,
    required this.left,
    required this.progress,
    super.key,
    this.urgent = false,
    this.onTap,
  });

  final String subject;
  final String task;
  final String due;

  final String left;
  final double progress;
  final bool urgent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = urgent ? colors.error : colors.primary;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: AppPressable(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AppProgressRing(
                      value: progress,
                      size: 44,
                      strokeWidth: 4,
                      color: accent,
                    ),
                    Text(
                      urgent ? '🔥' : '📋',
                      style: const TextStyle(fontSize: 16, height: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.active,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$subject · $due',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: colors.deactive),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.gap),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: urgent
                      ? colors.error.withValues(alpha: 0.16)
                      : colors.surfaceHigh,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  left,
                  style: AppText.chip.copyWith(
                    color: urgent ? colors.error : colors.deactive,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
