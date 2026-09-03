import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_share_event.dart';
import 'package:schedule_repository/schedule_repository.dart';

List<LessonSchedulePart> scheduleShareLessons(
  List<LessonSchedulePart> lessons, {
  required DateTime day,
  required int period,
}) {
  final (first, last) = scheduleShareRange(day: day, period: period);
  return [
    for (final lesson in lessons)
      if (lesson.dates.any(
        (date) => !date.isBefore(first) && date.isBefore(last),
      ))
        lesson.copyWith(
          dates: lesson.dates
              .where((date) => !date.isBefore(first) && date.isBefore(last))
              .toList(),
        ),
  ];
}

(DateTime, DateTime) scheduleShareRange({
  required DateTime day,
  required int period,
}) {
  final first = period == 0
      ? dateOnly(day)
      : period == 1
      ? weekStartFor(day)
      : DateTime(
          day.month >= 9 || day.month == 1
              ? (day.month == 1 ? day.year - 1 : day.year)
              : day.year,
          day.month >= 9 || day.month == 1 ? 9 : 2,
        );
  final last = period == 0
      ? first.add(const Duration(days: 1))
      : period == 1
      ? first.add(const Duration(days: 7))
      : DateTime(
          first.year + (first.month == 9 ? 1 : 0),
          first.month == 9 ? 2 : 9,
        );
  return (first, last);
}

String scheduleShareText(
  AppLocalizations l10n,
  String name,
  List<LessonSchedulePart> lessons, {
  List<ScheduleShareEvent> events = const [],
}) => [
  name,
  ..._shareOccurrences(lessons, events).map((occurrence) {
    final (date, lesson, event) = occurrence;
    if (event != null) {
      final day = DateFormat.yMMMd(l10n.localeName).format(date);
      return [
        '$day · ${_eventTime(l10n, event)}',
        event.title,
        [event.label, ?event.location, ?event.description].join(' · '),
      ].join('\n');
    }
    return '${DateFormat.yMMMd(l10n.localeName).format(date)} · '
        '${timeRangeText(lesson!)}\n${lesson.subject}\n'
        '${lessonMetaText(l10n, lesson)}';
  }),
].join('\n\n');

int scheduleShareOccurrenceCount(
  List<LessonSchedulePart> lessons, {
  List<ScheduleShareEvent> events = const [],
}) => _occurrences(lessons).length + events.length;

String _eventTime(AppLocalizations l10n, ScheduleShareEvent event) {
  if (event.allDay) return l10n.exportAllDay;
  final start = event.start;
  if (start == null) return event.label;
  final from = DateFormat.Hm(l10n.localeName).format(start);
  return event.end == null
      ? from
      : '$from–${DateFormat.Hm(l10n.localeName).format(event.end!)}';
}

List<(DateTime, LessonSchedulePart?, ScheduleShareEvent?)> _shareOccurrences(
  List<LessonSchedulePart> lessons,
  List<ScheduleShareEvent> events,
) => [
  for (final (date, lesson) in _occurrences(lessons)) (date, lesson, null),
  for (final event in events) (event.start ?? event.date, null, event),
]..sort((a, b) => a.$1.compareTo(b.$1));

List<(DateTime, LessonSchedulePart)> _occurrences(
  List<LessonSchedulePart> lessons,
) {
  final unique = <String, (DateTime, LessonSchedulePart)>{};
  for (final lesson in lessons) {
    for (final day in lesson.dates) {
      final date = atTime(day, lesson.lessonBells.startTime);
      unique[_identity(date, lesson)] = (date, lesson);
    }
  }
  return unique.values.toList()..sort((a, b) => a.$1.compareTo(b.$1));
}

String _identity(DateTime date, LessonSchedulePart lesson) => jsonEncode([
  lesson.uid,
  lesson.subject,
  lesson.lessonType.name,
  date.toIso8601String(),
  '${lesson.lessonBells.endTime}',
  lesson.classrooms.map((room) => room.name).toList()..sort(),
  lesson.teachers.map((teacher) => teacher.name).toList()..sort(),
]);

String _foldCalendarLine(String line) {
  final buffer = StringBuffer();
  var octets = 0;
  for (final rune in line.runes) {
    final char = String.fromCharCode(rune);
    final size = utf8.encode(char).length;
    if (octets + size > 75) {
      buffer.write('\r\n ');
      octets = 1;
    }
    buffer.write(char);
    octets += size;
  }
  return buffer.toString();
}

String scheduleShareCalendar(
  AppLocalizations l10n,
  List<LessonSchedulePart> lessons, {
  required bool reminders,
  List<ScheduleShareEvent> events = const [],
}) {
  String stamp(DateTime date) =>
      DateFormat("yyyyMMdd'T'HHmmss'Z'").format(date.toUtc());
  String escape(String text) => text
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .replaceAll(r'\', r'\\')
      .replaceAll('\n', r'\n')
      .replaceAll(',', r'\,')
      .replaceAll(';', r'\;');
  final lines = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//University//Schedule//EN',
    'CALSCALE:GREGORIAN',
  ];
  for (final (date, lesson) in _occurrences(lessons)) {
    final location = escape(
      lesson.classrooms.map((room) => room.name).join(', '),
    );
    var end = atTime(date, lesson.lessonBells.endTime);
    if (!end.isAfter(date)) end = end.add(const Duration(days: 1));
    lines.addAll([
      'BEGIN:VEVENT',
      'UID:${Uri.encodeComponent(_identity(date, lesson))}@university',
      'DTSTAMP:${stamp(DateTime.now())}',
      'DTSTART:${stamp(date)}',
      'DTEND:${stamp(end)}',
      'SUMMARY:${escape(lesson.subject)}',
      'LOCATION:$location',
      'DESCRIPTION:${escape(lessonMetaText(l10n, lesson))}',
      if (reminders) ...[
        'BEGIN:VALARM',
        'TRIGGER:-PT15M',
        'ACTION:DISPLAY',
        'DESCRIPTION:${escape(lesson.subject)}',
        'END:VALARM',
      ],
      'END:VEVENT',
    ]);
  }
  for (final event in events.where((event) => event.canExportCalendar)) {
    final date = DateFormat('yyyyMMdd').format(event.date);
    final id = Uri.encodeComponent('${event.id}:$date:${event.start ?? ''}');
    final next = DateFormat(
      'yyyyMMdd',
    ).format(event.date.add(const Duration(days: 1)));
    lines.addAll([
      'BEGIN:VEVENT',
      'UID:$id@university',
      'DTSTAMP:${stamp(DateTime.now())}',
      if (event.allDay)
        'DTSTART;VALUE=DATE:$date'
      else
        'DTSTART:${stamp(event.start!)}',
      if (event.allDay)
        'DTEND;VALUE=DATE:$next'
      else if (event.end != null && event.end!.isAfter(event.start!))
        'DTEND:${stamp(event.end!)}',
      'SUMMARY:${escape(event.title)}',
      'LOCATION:${escape(event.location ?? '')}',
      'DESCRIPTION:${escape([event.label, ?event.description].join('\n'))}',
      if (reminders && !event.allDay) ...[
        'BEGIN:VALARM',
        'TRIGGER:-PT15M',
        'ACTION:DISPLAY',
        'DESCRIPTION:${escape(event.title)}',
        'END:VALARM',
      ],
      'END:VEVENT',
    ]);
  }
  final folded = [
    ...lines,
    'END:VCALENDAR',
  ].map(_foldCalendarLine).join('\r\n');
  return '$folded\r\n';
}

Future<List<Uint8List>> scheduleShareImages(
  BuildContext context,
  String name,
  List<LessonSchedulePart> lessons, {
  List<ScheduleShareEvent> events = const [],
}) async {
  final colors = context.colors;
  final l10n = context.l10n;
  final rows = _shareOccurrences(lessons, events);
  const width = 1080;
  const height = 1600;
  const padding = 48.0;
  const contentTop = 214.0;
  const contentBottom = height - 108.0;
  final direction = Directionality.of(context);
  TextPainter text(String value, TextStyle style, {double inset = 0}) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: style),
      textDirection: direction,
    )..layout(maxWidth: width - padding * 2 - inset);
    return painter;
  }

  final blocks = <_ScheduleImageBlock>[];
  DateTime? previousDay;
  for (final (date, lesson, event) in rows) {
    final day = dateOnly(date);
    if (day != previousDay) {
      previousDay = day;
      blocks.add(
        _ScheduleImageBlock(
          painter: text(
            DateFormat.yMMMMEEEEd(l10n.localeName).format(day),
            AppText.sans(28, FontWeight.w700).copyWith(color: colors.muted),
          ),
          isHeading: true,
          accent: colors.accent,
        ),
      );
    }
    final accent = lesson == null
        ? (event!.personal ? colors.ink : colors.accent)
        : lessonAccentOf(context, lesson);
    final time = lesson == null
        ? _eventTime(l10n, event!)
        : timeRangeText(lesson);
    final label = lesson == null
        ? event!.label
        : lessonTypeName(l10n, lesson.lessonType);
    final dateLabel = DateFormat.MMMd(l10n.localeName).format(date);
    final details = lesson == null
        ? [?event!.location, ?event.description]
        : [
            if (lesson.classrooms.isEmpty) l10n.classroomNotSpecified,
            ...lesson.classrooms.map(
              (room) => [
                room.name,
                if (room.campus != null) room.campus!.name,
              ].join(' · '),
            ),
            ...lesson.teachers.map((teacher) => teacher.name),
          ];
    blocks.add(
      _ScheduleImageBlock(
        painter: TextPainter(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$dateLabel · $time\n$label\n',
                style: AppText.sans(
                  27,
                  FontWeight.w700,
                  height: 1.6,
                ).copyWith(color: accent),
              ),
              TextSpan(
                text: '${lesson?.subject ?? event!.title}\n',
                style: AppText.sans(
                  36,
                  FontWeight.w600,
                  height: 1.25,
                ).copyWith(color: colors.ink),
              ),
              TextSpan(
                text: details.join('\n'),
                style: AppText.sans(
                  26,
                  FontWeight.w500,
                  height: 1.4,
                ).copyWith(color: colors.muted),
              ),
            ],
          ),
          textDirection: direction,
        )..layout(maxWidth: width - padding * 2 - 64),
        isHeading: false,
        accent: accent,
      ),
    );
  }
  final pages = <List<_ScheduleImageSlice>>[[]];
  var y = contentTop;
  for (var index = 0; index < blocks.length; index++) {
    final block = blocks[index];
    final inset = block.isHeading ? 0.0 : 24.0;
    final blockHeight = block.painter.height + inset * 2;
    final nextHeight = block.isHeading && index + 1 < blocks.length
        ? (blocks[index + 1].painter.height + 68).clamp(0, 300)
        : 0;
    if (y > contentTop && y + blockHeight + nextHeight > contentBottom) {
      pages.add([]);
      y = contentTop;
    }
    var consumed = 0.0;
    while (consumed < block.painter.height) {
      final available = contentBottom - y - inset * 2;
      final remaining = block.painter.height - consumed;
      var sliceHeight = remaining;
      if (sliceHeight > available) {
        final boundaries = block.painter
            .computeLineMetrics()
            .map((line) => line.baseline + line.descent)
            .where((end) => end > consumed && end - consumed <= available)
            .toList();
        if (boundaries.isEmpty) {
          pages.add([]);
          y = contentTop;
          continue;
        }
        sliceHeight = boundaries.last - consumed;
      }
      pages.last.add(_ScheduleImageSlice(block, y, consumed, sliceHeight));
      y += sliceHeight + inset * 2 + 20;
      consumed += sliceHeight;
      if (consumed < block.painter.height) {
        pages.add([]);
        y = contentTop;
      }
    }
  }
  final images = <Uint8List>[];
  try {
    for (final (index, page) in pages.indexed) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder)..drawColor(colors.canvas, BlendMode.src);
      final title = text(name, AppText.serif(50).copyWith(color: colors.ink));
      canvas
        ..save()
        ..clipRect(
          const Rect.fromLTWH(padding, 80, width - padding * 2, 110),
        );
      title.paint(canvas, const Offset(padding, 80));
      canvas.restore();
      title.dispose();
      text(
          l10n.scheduleLessonsTitle.toUpperCase(),
          AppText.sans(22, FontWeight.w700).copyWith(color: colors.accent),
        )
        ..paint(canvas, const Offset(padding, 40))
        ..dispose();
      for (final slice in page) {
        final block = slice.block;
        final inset = block.isHeading ? 0.0 : 24.0;
        if (!block.isHeading) {
          final rect = Rect.fromLTWH(
            padding,
            slice.y,
            width - padding * 2,
            slice.height + inset * 2,
          );
          canvas
            ..drawRRect(
              RRect.fromRectAndRadius(
                rect,
                const Radius.circular(AppRadius.dialog),
              ),
              Paint()..color = colors.surface,
            )
            ..drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(padding + 12, slice.y + 24, 5, slice.height),
                const Radius.circular(AppRadius.bar),
              ),
              Paint()..color = block.accent,
            );
        }
        canvas
          ..save()
          ..clipRect(
            Rect.fromLTWH(
              padding,
              slice.y + inset,
              width - padding * 2,
              slice.height,
            ),
          );
        block.painter.paint(
          canvas,
          Offset(
            padding + (block.isHeading ? 0 : 32),
            slice.y + inset - slice.offset,
          ),
        );
        canvas.restore();
      }
      text(
          '${l10n.exportEntriesCount(rows.length)} · ${index + 1}/${pages.length}',
          AppText.sans(24, FontWeight.w600).copyWith(color: colors.muted),
        )
        ..paint(canvas, const Offset(padding, height - 64))
        ..dispose();
      final picture = recorder.endRecording();
      final image = await picture.toImage(width, height);
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) throw const FormatException('Image encoding failed');
        images.add(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
      } finally {
        picture.dispose();
        image.dispose();
      }
    }
    return images;
  } finally {
    for (final block in blocks) {
      block.painter.dispose();
    }
  }
}

class _ScheduleImageBlock {
  const _ScheduleImageBlock({
    required this.painter,
    required this.isHeading,
    required this.accent,
  });
  final TextPainter painter;
  final bool isHeading;
  final Color accent;
}

class _ScheduleImageSlice {
  const _ScheduleImageSlice(this.block, this.y, this.offset, this.height);
  final _ScheduleImageBlock block;
  final double y;
  final double offset;
  final double height;
}
