import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleNotPairedView extends StatelessWidget {
  const ScheduleNotPairedView({required this.isAmbient, super.key});

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
                    ? colors.primary.withValues(alpha: 0.1)
                    : colors.surfaceLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive
                      ? colors.primary.withValues(alpha: 0.3)
                      : colors.borderLight,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.watch_outlined,
                size: 28,
                color: isActive ? colors.primary : colors.deactiveDarker,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Не подключено',
              textAlign: TextAlign.center,
              style: AppText.heading.copyWith(
                color: isActive ? colors.active : colors.deactive,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Подключите часы к телефону',
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(
                color: colors.deactiveDarker,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
