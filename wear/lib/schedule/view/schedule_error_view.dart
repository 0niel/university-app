import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wear/schedule/schedule.dart';

class ScheduleErrorView extends StatelessWidget {
  const ScheduleErrorView({required this.isAmbient, super.key});

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
                    ? colors.error.withValues(alpha: 0.1)
                    : colors.surfaceLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive
                      ? colors.error.withValues(alpha: 0.3)
                      : colors.borderLight,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 28,
                color: isActive ? colors.error : colors.deactiveDarker,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ошибка загрузки',
              textAlign: TextAlign.center,
              style: AppText.heading.copyWith(
                color: isActive ? colors.active : colors.deactive,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Не удалось получить расписание',
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(
                color: colors.deactiveDarker,
                fontSize: 10,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    unawaited(
                      context.read<ScheduleCubit>().requestScheduleFromPhone(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Повторить',
                    style: AppText.button.copyWith(fontSize: 11),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
