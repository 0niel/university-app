import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleLoadingView extends StatefulWidget {
  const ScheduleLoadingView({
    required this.isAmbient,
    required this.isPaired,
    required this.isReachable,
    super.key,
  });

  final bool isAmbient;
  final bool isPaired;
  final bool isReachable;

  @override
  State<ScheduleLoadingView> createState() => _ScheduleLoadingViewState();
}

class _ScheduleLoadingViewState extends State<ScheduleLoadingView> {
  Timer? _timer;
  int _secondsWaiting = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _secondsWaiting++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final isActive = !widget.isAmbient;
    final isWaitingLong = _secondsWaiting > 5;
    final statusText = switch ((widget.isPaired, widget.isReachable)) {
      (false, _) => 'Не подключено',
      (true, false) => 'Подключение...',
      (true, true) => 'Загрузка...',
    };
    final instructionText = switch ((widget.isPaired, widget.isReachable)) {
      (false, _) => 'Подключите часы\nв Wear OS',
      (true, false) => 'Убедитесь, что телефон рядом',
      (true, true) when isWaitingLong => 'Это займет больше времени...',
      (true, true) => 'Получение данных с телефона',
    };
    final icon = switch ((widget.isPaired, widget.isReachable)) {
      (false, _) => Icons.watch_off_outlined,
      (true, false) => Icons.smartphone_outlined,
      (true, true) => Icons.sync_rounded,
    };

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
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isActive && !isWaitingLong)
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          colors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  Icon(
                    icon,
                    size: 24,
                    color: isActive ? colors.primary : colors.deactiveDarker,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: AppText.heading.copyWith(
                color: isActive ? colors.active : colors.deactive,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              instructionText,
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
