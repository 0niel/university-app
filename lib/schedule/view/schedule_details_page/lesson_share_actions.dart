part of '../schedule_details_page.dart';

mixin _LessonShareActions on State<ScheduleDetailsPage> {
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
        backgroundColor: context.colors.canvas,
        contentPadding: EdgeInsets.zero,
        child: CustomScheduleSelector(lesson: widget.lesson),
      ),
    );
  }
}
