part of '../schedule_details_page.dart';

mixin _LessonShareActions on State<ScheduleDetailsPage> {
  void _shareLesson() {
    final teachers = _teacherLine(widget.lesson);
    final lessonTypeAndTime =
        '${_lessonTypeName(context.l10n, widget.lesson)} · '
        '${_timeRange(widget.lesson)}';
    unawaited(
      SharePlus.instance.share(
        ShareParams(
          text:
              '${widget.lesson.subject}\n'
              '$lessonTypeAndTime\n'
              '${_classroomLine(context.l10n, widget.lesson)}\n'
              '${teachers.isEmpty ? '' : teachers}',
        ),
      ),
    );
    unawaited(HapticFeedback.lightImpact());
  }

  void _openRoute() {
    final classroom = widget.lesson.classrooms.firstOrNull;
    final campus = classroom?.campus;
    final latitude = campus?.latitude;
    final longitude = campus?.longitude;
    if (latitude == null || longitude == null) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsRoomCoordsMissing,
      );
      return;
    }

    unawaited(
      launchUrlString(
        'https://yandex.ru/maps/?rtext=~$latitude,$longitude',
        mode: .externalApplication,
      ),
    );
  }

  void _showAddToCustomScheduleModal() {
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.lessonDetailsAddToSchedule,
        backgroundColor: context.ninja.canvas,
        contentPadding: EdgeInsets.zero,
        child: CustomScheduleSelector(lesson: widget.lesson),
      ),
    );
  }
}
