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
        NinjaSegmented<LessonRepeat>(
          value: _repeat,
          expanded: true,
          segments: [
            NinjaSegment(
              value: LessonRepeat.everyWeek,
              label: l10n.lessonEditorRepeatEveryShort,
            ),
            NinjaSegment(
              value: LessonRepeat.evenWeek,
              label: l10n.lessonEditorRepeatEvenShort,
            ),
            NinjaSegment(
              value: LessonRepeat.oddWeek,
              label: l10n.lessonEditorRepeatOddShort,
            ),
          ],
          onChanged: _select,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.lessonEditorDatesCount(_dates.length),
          textAlign: .center,
          style: NinjaText.subtext.copyWith(color: context.ninja.muted),
        ),
        const SizedBox(height: 16),
        NinjaButton.secondary(
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
        const SizedBox(height: 10),
        NinjaButton.primary(
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
