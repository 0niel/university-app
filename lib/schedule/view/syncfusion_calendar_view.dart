import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:university_app_server_api/client.dart';

class SyncfusionCalendarView extends StatefulWidget {
  final List<SchedulePart> lessons;
  const SyncfusionCalendarView({super.key, required this.lessons});

  @override
  State<SyncfusionCalendarView> createState() => _SyncfusionCalendarViewState();
}

class _SyncfusionCalendarViewState extends State<SyncfusionCalendarView> {
  late _AppointmentDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _AppointmentDataSource(_getAppointments());
  }

  List<Appointment> _getAppointments() {
    return widget.lessons.whereType<LessonSchedulePart>().map((lesson) {
      final DateTime lessonDate = lesson.dates.first;
      final DateTime startTime = DateTime(
        lessonDate.year,
        lessonDate.month,
        lessonDate.day,
        lesson.lessonBells.startTime.hour,
        lesson.lessonBells.startTime.minute,
      );
      final DateTime endTime = DateTime(
        lessonDate.year,
        lessonDate.month,
        lessonDate.day,
        lesson.lessonBells.endTime.hour,
        lesson.lessonBells.endTime.minute,
      );

      final subjectDetails = '${lesson.subject}\nТип: ${LessonCard.getLessonTypeName(lesson.lessonType)}';
      final teacherNames =
          lesson.teachers.isNotEmpty ? 'Преподаватели: ${lesson.teachers.map((t) => t.name).join(', ')}' : '';
      final classroomNames = lesson.classrooms.map((c) => c.name).join(', ');

      return Appointment(
        startTime: startTime,
        endTime: endTime,
        startTimeZone: 'Russian Standard Time',
        endTimeZone: 'Russian Standard Time',
        recurrenceRule: '',
        isAllDay: false,
        notes: teacherNames,
        location: classroomNames,
        resourceIds: [lesson.lessonType],
        recurrenceId: null,
        id: lesson.hashCode,
        subject: subjectDetails,
        color: LessonCard.getColorByType(lesson.lessonType),
        recurrenceExceptionDates: [],
      );
    }).toList();
  }

  Widget buildCalendar() {
    return SfCalendar(
      onTap: (_) {},
      timeZone: 'Russian Standard Time',
      view: CalendarView.month,
      firstDayOfWeek: 1,
      headerDateFormat: 'MMMM yyyy',
      dataSource: _dataSource,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: const Duration(minutes: 30),
        timeIntervalHeight: 70,
        timeTextStyle: AppTextStyle.captionL,
      ),
      headerStyle: CalendarHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: AppTextStyle.titleM.copyWith(color: Theme.of(context).extension<AppColors>()!.active),
        backgroundColor: Theme.of(context).extension<AppColors>()!.background01,
      ),
      cellBorderColor: Theme.of(context).extension<AppColors>()!.divider,
      todayHighlightColor: Theme.of(context).extension<AppColors>()!.colorful01,
      appointmentTextStyle: const TextStyle(fontSize: 12),
      allowViewNavigation: true,
      showDatePickerButton: false,
      showNavigationArrow: true,
      showCurrentTimeIndicator: true,
      showWeekNumber: false,
      viewNavigationMode: ViewNavigationMode.snap,
      monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCalendar();
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
