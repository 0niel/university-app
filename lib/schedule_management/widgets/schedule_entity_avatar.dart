import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:schedule_repository/schedule_repository.dart';

AppLineIcon scheduleTargetIcon(ScheduleTarget target) => switch (target) {
  .group => AppLineIcon.people,
  .teacher => AppLineIcon.user,
  .classroom => AppLineIcon.pin,
};

String scheduleGroupBadge(String name) {
  final parts = name.split(RegExp(r'[-\s]'));
  final secondPart = parts.elementAtOrNull(1);
  if (secondPart != null &&
      secondPart.length == 2 &&
      int.tryParse(secondPart) != null) {
    return secondPart;
  }
  final digits = RegExp(r'\d{1,2}').firstMatch(name)?.group(0);
  if (digits != null) return digits.padLeft(2, '0');
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '—';
  return (trimmed.length >= 2 ? trimmed.substring(0, 2) : trimmed)
      .toUpperCase();
}

class ScheduleEntityAvatar extends StatelessWidget {
  const ScheduleEntityAvatar({
    required this.target,
    required this.name,
    super.key,
    this.size = 44,
  });

  final ScheduleTarget target;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = switch (target) {
      .group => colors.accent,
      .teacher => colors.warn,
      .classroom => colors.lecture,
    };

    final Widget content = target == .group
        ? Text(
            scheduleGroupBadge(name),
            style: AppText.tabular(
              AppText.headline.copyWith(
                fontSize: size * 0.34,
                color: accent,
              ),
            ),
          )
        : AppLineIconWidget(
            scheduleTargetIcon(target),
            size: size * 0.44,
            color: accent,
          );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: colors.isDark ? 0.22 : 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
