import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/utils/lesson_repeat.dart';

class LessonEditorRepeatSheet extends StatefulWidget {
  const LessonEditorRepeatSheet({
    required this.repeat,
    required this.weekday,
    required this.dates,
    this.reference,
    super.key,
  });

  final LessonRepeat repeat;
  final int weekday;
  final List<DateTime> dates;
  final DateTime? reference;

  @override
  State<LessonEditorRepeatSheet> createState() =>
      _LessonEditorRepeatSheetState();
}

class _LessonEditorRepeatSheetState extends State<LessonEditorRepeatSheet> {
  late LessonRepeat _repeat;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _repeat = widget.repeat == .custom ? .everyWeek : widget.repeat;
    _dates = widget.repeat == .custom
        ? widget.dates.toList()
        : expandRepeat(
            weekday: widget.weekday,
            repeat: _repeat,
            reference: widget.reference,
          );
  }

  void _select(LessonRepeat repeat) {
    setState(() {
      _repeat = repeat;
      _dates = expandRepeat(
        weekday: widget.weekday,
        repeat: repeat,
        reference: widget.reference,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        AppSegmented<LessonRepeat>(
          value: _repeat,
          segments: [
            AppSegment(
              value: LessonRepeat.everyWeek,
              label: l10n.lessonEditorRepeatEveryShort,
            ),
            AppSegment(
              value: LessonRepeat.evenWeek,
              label: l10n.lessonEditorRepeatEvenShort,
            ),
            AppSegment(
              value: LessonRepeat.oddWeek,
              label: l10n.lessonEditorRepeatOddShort,
            ),
          ],
          onChanged: _select,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.lessonEditorDatesCount(_dates.length),
          textAlign: .center,
          style: AppText.subtext.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.secondary(
          label: l10n.lessonEditorRepeatManual,
          expanded: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(
            LessonEditorRepeatResult(
              repeat: .custom,
              dates: _dates,
              openManual: true,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.gap),
        AppButton.primary(
          label: l10n.done,
          expanded: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(
            LessonEditorRepeatResult(repeat: _repeat, dates: _dates),
          ),
        ),
      ],
    );
  }
}

class LessonEditorRepeatResult {
  const LessonEditorRepeatResult({
    required this.repeat,
    required this.dates,
    this.openManual = false,
  });

  final LessonRepeat repeat;
  final List<DateTime> dates;
  final bool openManual;
}
