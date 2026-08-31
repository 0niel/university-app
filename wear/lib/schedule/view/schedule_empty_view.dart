import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleEmptyView extends StatelessWidget {
  const ScheduleEmptyView({required this.isAmbient, super.key});

  final bool isAmbient;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final isActive = !isAmbient;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isActive
                    ? colors.deactive.withValues(alpha: 0.1)
                    : colors.surfaceLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 28,
                color: isActive ? colors.deactive : colors.deactiveDarker,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Нет расписания',
              textAlign: TextAlign.center,
              style: AppText.heading.copyWith(
                color: isActive ? colors.active : colors.deactive,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Откройте приложение\nна телефоне',
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(
                color: colors.deactiveDarker,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
