import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SyncfusionCalendarView extends StatefulWidget {
  const SyncfusionCalendarView({required this.lessons, super.key});
  final List<SchedulePart> lessons;

  @override
  State<SyncfusionCalendarView> createState() => _SyncfusionCalendarViewState();
}

class _SyncfusionCalendarViewState extends State<SyncfusionCalendarView> {
  late _AppointmentDataSource _dataSource;
  bool _dataSourceReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataSourceReady) {
      _dataSource = _AppointmentDataSource(_getAppointments(context.l10n));
      _dataSourceReady = true;
    }
  }

  List<Appointment> _getAppointments(AppLocalizations l10n) {
    return widget.lessons
        .whereType<LessonSchedulePart>()
        .map((lesson) {
          final lessonDate = lesson.dates.firstOrNull;
          if (lessonDate == null) return null;
          final startTime = DateTime(
            lessonDate.year,
            lessonDate.month,
            lessonDate.day,
            lesson.lessonBells.startTime.hour,
            lesson.lessonBells.startTime.minute,
          );
          final endTime = DateTime(
            lessonDate.year,
            lessonDate.month,
            lessonDate.day,
            lesson.lessonBells.endTime.hour,
            lesson.lessonBells.endTime.minute,
          );

          final subjectDetails =
              '${lesson.subject}\nТип: '
              '${LessonCard.getLessonTypeName(l10n, lesson.lessonType)}';
          final teacherNames = lesson.teachers.isNotEmpty
              ? 'Преподаватели: '
                    '${lesson.teachers.map((t) => t.name).join(', ')}'
              : '';
          final classroomNames = lesson.classrooms
              .map((c) => c.name)
              .join(', ');

          return Appointment(
            startTime: startTime,
            endTime: endTime,
            startTimeZone: 'Russian Standard Time',
            endTimeZone: 'Russian Standard Time',
            recurrenceRule: '',
            notes: teacherNames,
            location: classroomNames,
            resourceIds: [lesson.lessonType],
            id: lesson.hashCode,
            subject: subjectDetails,
            color: LessonCard.colorOf(lesson),
            recurrenceExceptionDates: [],
          );
        })
        .whereType<Appointment>()
        .toList();
  }

  Widget buildCalendar() {
    return SfCalendar(
      timeZone: 'Russian Standard Time',
      view: .month,
      firstDayOfWeek: 1,
      headerDateFormat: 'MMMM yyyy',
      dataSource: _dataSource,
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeInterval: Duration(minutes: 30),
        timeIntervalHeight: 70,
        timeTextStyle: NinjaText.subtext,
      ),
      headerStyle: CalendarHeaderStyle(
        textAlign: .center,
        textStyle: NinjaText.headline.copyWith(
          color: context.ninja.ink,
        ),
        backgroundColor: context.ninja.canvas,
      ),
      cellBorderColor: context.ninja.line,
      todayHighlightColor: context.ninja.indigo,
      appointmentTextStyle: const TextStyle(fontSize: 12),
      allowViewNavigation: true,
      showNavigationArrow: true,
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: .appointment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCalendar();
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
