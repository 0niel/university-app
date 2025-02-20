import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:university_app_server_api/client.dart';
import 'package:flutter/scheduler.dart';

class ConsecutiveBreakWidget extends StatefulWidget {
  final List<LessonSchedulePart> currentLessons;
  final List<LessonSchedulePart> nextLessons;

  const ConsecutiveBreakWidget({
    super.key,
    required this.currentLessons,
    required this.nextLessons,
  });

  @override
  State<ConsecutiveBreakWidget> createState() => _ConsecutiveBreakWidgetState();
}

class _ConsecutiveBreakWidgetState extends State<ConsecutiveBreakWidget> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double? _progress;

  double? _computeProgress() {
    final now = DateTime.now();
    final currentMax = widget.currentLessons
        .map((l) => l.lessonBells.endTime.hour * 60 + l.lessonBells.endTime.minute)
        .reduce((a, b) => a > b ? a : b);
    final nextMin = widget.nextLessons
        .map((l) => l.lessonBells.startTime.hour * 60 + l.lessonBells.startTime.minute)
        .reduce((a, b) => a < b ? a : b);
    final today = DateTime(now.year, now.month, now.day);
    final breakStart = DateTime(today.year, today.month, today.day, currentMax ~/ 60, currentMax % 60);
    final breakEnd = DateTime(today.year, today.month, today.day, nextMin ~/ 60, nextMin % 60);
    if (now.isAfter(breakStart) && now.isBefore(breakEnd)) {
      return now.difference(breakStart).inSeconds / breakEnd.difference(breakStart).inSeconds;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _progress = _computeProgress();
    _ticker = createTicker((_) {
      final newProgress = _computeProgress();
      if ((newProgress == null && _progress != null) ||
          (newProgress != null && _progress == null) ||
          (newProgress != null && _progress != null && (newProgress - _progress!).abs() > 0.001)) {
        setState(() {
          _progress = newProgress;
        });
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  Widget _buildContent(String breakText, TextStyle textStyle) {
    return Row(
      children: [
        Text(
          'Перерыв',
          style: textStyle,
        ),
        const Spacer(),
        HugeIcon(
          icon: HugeIcons.strokeRoundedTime01,
          color: Theme.of(context).extension<AppColors>()!.deactive,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          breakText,
          style: textStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMax =
        widget.currentLessons.map((l) => _toMinutes(l.lessonBells.endTime)).reduce((a, b) => a > b ? a : b);
    final nextMin = widget.nextLessons.map((l) => _toMinutes(l.lessonBells.startTime)).reduce((a, b) => a < b ? a : b);
    final breakDuration = nextMin - currentMax;
    final breakText = breakDuration > 0 ? '$breakDuration мин' : 'отсутствует';

    final textStyle = AppTextStyle.captionL.copyWith(
      color: Theme.of(context).extension<AppColors>()!.deactive,
    );

    if (_progress != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: _progress!, end: _progress!),
          duration: const Duration(milliseconds: 300),
          builder: (context, animatedProgress, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [animatedProgress, animatedProgress],
                  colors: [
                    Theme.of(context).extension<AppColors>()!.colorful03,
                    Theme.of(context).extension<AppColors>()!.colorful03.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildContent(breakText, textStyle),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).extension<AppColors>()!.deactiveDarker),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: _buildContent(breakText, textStyle),
        ),
      );
    }
  }
}

class WindowBreakWidget extends StatelessWidget {
  final int windowCount;

  const WindowBreakWidget({
    super.key,
    required this.windowCount,
  });

  String _pluralizeWindow(int count) {
    return Intl.plural(
      count,
      one: '$count пару',
      few: '$count пары',
      many: '$count пар',
      other: '$count пар',
    );
  }

  @override
  Widget build(BuildContext context) {
    final windowText = 'Окно в ${_pluralizeWindow(windowCount)}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).extension<AppColors>()!.divider),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            windowText,
            style: AppTextStyle.captionL.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
          ),
        ),
      ),
    );
  }
}
