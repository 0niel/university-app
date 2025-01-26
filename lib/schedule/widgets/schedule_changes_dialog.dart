import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

class ScheduleChangesDialog extends StatelessWidget {
  final ScheduleDiff diff;

  const ScheduleChangesDialog({super.key, required this.diff});

  Icon _getChangeIcon(ChangeType type) {
    switch (type) {
      case ChangeType.added:
        return const Icon(Icons.add_circle, color: Colors.green);
      case ChangeType.removed:
        return const Icon(Icons.remove_circle, color: Colors.red);
      case ChangeType.modified:
        return const Icon(Icons.change_circle, color: Colors.orange);
      default:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }

  String _formatDates(List<DateTime> dates) {
    return dates.map((d) => DateFormat('dd MMM yyyy').format(d)).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Изменения в расписании',
              style: AppTextStyle.titleM,
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: diff.changes.length,
                itemBuilder: (context, index) {
                  final change = diff.changes.toList()[index];
                  return Row(
                    children: [
                      _getChangeIcon(change.type),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              change.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              change.description,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              _formatDates(change.dates),
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${change.lessonBells.startTime} - ${change.lessonBells.endTime}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 100.ms);
                },
              ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ).animate().fadeIn(duration: 300.ms, delay: 600.ms),
          ],
        ),
      ),
    );
  }
}

class SlideFadeTransition extends StatelessWidget {
  final int index;
  final Widget child;

  const SlideFadeTransition({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return child
        .animate(
          delay: Duration(milliseconds: 100 * index),
        )
        .slideY(begin: 0.3, end: 0.0, duration: 300.ms)
        .fadeIn();
  }
}
