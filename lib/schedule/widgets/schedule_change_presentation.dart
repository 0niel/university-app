import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleChangeDetail {
  const ScheduleChangeDetail({
    required this.label,
    required this.before,
    required this.after,
  });

  final String label;
  final String before;
  final String after;
}

class ScheduleChangePresentation {
  const ScheduleChangePresentation._({
    required this.subject,
    required this.title,
    required this.effectiveKind,
    required this.details,
    required this.context,
    required this.summary,
    required this.isSingleSnapshot,
  });

  factory ScheduleChangePresentation.fromChange(
    ScheduleChange change,
    AppLocalizations l10n,
  ) {
    final before = change.oldValue;
    final after = change.newValue;
    final single =
        change.kind == ScheduleChangeKind.add ||
        change.kind == ScheduleChangeKind.cancel;
    final current = change.kind == ScheduleChangeKind.cancel ? before : after;
    final missing = l10n.scheduleChangeUnavailable;
    String value(String? text) =>
        text == null || text.trim().isEmpty ? missing : text.trim();
    String type(String? name) => switch (name) {
      'lecture' => l10n.lecture,
      'practice' => l10n.practice,
      'laboratoryWork' || 'laboratory_work' => l10n.laboratory,
      'individualWork' || 'individual_work' => l10n.lessonTypeIndividualShort,
      'physicalEducation' || 'physical_education' => l10n.physicalEducation,
      'consultation' => l10n.consultation,
      'exam' => l10n.exam,
      'credit' => l10n.credit,
      'courseWork' || 'course_work' => l10n.lessonTypeCourseWorkShort,
      'courseProject' || 'course_project' => l10n.lessonTypeCourseProjectShort,
      'unknown' => l10n.unknown,
      _ => value(name),
    };
    String time(ScheduleChangeSlot slot) =>
        slot.start == null && slot.end == null
        ? missing
        : '${value(slot.start)} – ${value(slot.end)}';
    List<String> names(List<String> values) =>
        values
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    String date(DateTime date) =>
        DateFormat.yMMMd(l10n.localeName).format(date);
    List<String> dates(ScheduleChangeSlot slot) =>
        slot.dates.map(date).toSet().toList();
    bool equal(List<String> a, List<String> b) =>
        const SetEquality<String>().equals(a.toSet(), b.toSet());
    final details = <ScheduleChangeDetail>[];
    final context = <String>[];
    void field(String label, String oldText, String newText) {
      if (oldText != newText) {
        details.add(
          ScheduleChangeDetail(label: label, before: oldText, after: newText),
        );
      }
    }

    final oldDates = dates(before);
    final newDates = dates(after);
    final dateChanged = !equal(oldDates, newDates);
    final timeChanged = before.start != after.start || before.end != after.end;
    final roomsChanged = !equal(names(before.rooms), names(after.rooms));
    final teachersChanged = !equal(
      names(before.teachers),
      names(after.teachers),
    );
    if (!single) {
      if (dateChanged) {
        final removed = oldDates
            .where((item) => !newDates.contains(item))
            .toList();
        final added = newDates
            .where((item) => !oldDates.contains(item))
            .toList();
        field(
          l10n.scheduleChangeDate,
          value((removed.isEmpty ? oldDates : removed).join(', ')),
          value((added.isEmpty ? newDates : added).join(', ')),
        );
      }
      if (timeChanged) {
        field(l10n.scheduleDiffFieldTime, time(before), time(after));
      }
      if (roomsChanged) {
        field(
          l10n.scheduleDiffFieldClassrooms,
          value(names(before.rooms).join(', ')),
          value(names(after.rooms).join(', ')),
        );
      }
      if (teachersChanged) {
        field(
          l10n.scheduleDiffFieldTeachers,
          value(names(before.teachers).join(', ')),
          value(names(after.teachers).join(', ')),
        );
      }
      field(
        l10n.scheduleDiffFieldNumber,
        value(before.lessonNumber?.toString()),
        value(after.lessonNumber?.toString()),
      );
      field(
        l10n.scheduleDiffFieldLessonType,
        type(before.lessonType),
        type(after.lessonType),
      );
      field(
        l10n.scheduleChangeSubjectLabel,
        value(before.subject),
        value(after.subject),
      );
    }
    if (!dateChanged || single) context.add(date(change.lessonDate));
    if (!timeChanged || single) {
      if (current.start != null || current.end != null) {
        context.add(time(current));
      }
    }
    if ((!roomsChanged || single) && current.rooms.isNotEmpty) {
      context.add(
        '${l10n.scheduleDiffFieldClassrooms}: '
        '${names(current.rooms).join(', ')}',
      );
    }
    if ((!teachersChanged || single) && current.teachers.isNotEmpty) {
      context.add(
        '${l10n.scheduleDiffFieldTeachers}: '
        '${names(current.teachers).join(', ')}',
      );
    }
    if (single && current.lessonNumber != null) {
      context.add('${l10n.scheduleDiffFieldNumber}: ${current.lessonNumber}');
    }
    if (single && current.lessonType != null) {
      context.add(
        '${l10n.scheduleDiffFieldLessonType}: ${type(current.lessonType)}',
      );
    }
    final knownDateChange =
        dateChanged && oldDates.isNotEmpty && newDates.isNotEmpty;
    final knownTimeChange =
        before.start != null &&
            after.start != null &&
            before.start != after.start ||
        before.end != null && after.end != null && before.end != after.end;
    final effectiveKind = single
        ? change.kind
        : knownDateChange || knownTimeChange
        ? ScheduleChangeKind.move
        : details.length == 1 && roomsChanged
        ? ScheduleChangeKind.room
        : details.length == 1 && teachersChanged
        ? ScheduleChangeKind.teacher
        : ScheduleChangeKind.update;
    final renamed =
        !single &&
        before.subject != null &&
        after.subject != null &&
        before.subject != after.subject &&
        details.length == 1;
    final title = switch (effectiveKind) {
      ScheduleChangeKind.add => l10n.scheduleChangeTagNew,
      ScheduleChangeKind.cancel => l10n.scheduleChangeTagCancelled,
      ScheduleChangeKind.move => l10n.scheduleChangeTagMoved,
      ScheduleChangeKind.room => l10n.changeRoomTitle,
      ScheduleChangeKind.teacher => l10n.changeTeacherTitle,
      ScheduleChangeKind.update =>
        renamed ? l10n.scheduleChangeRenamed : l10n.scheduleChangeUpdated,
    };
    final subjectText = current.subject ?? change.subject;
    final subject = value(subjectText) == missing
        ? l10n.scheduleChangeSubjectUnavailable
        : subjectText.trim();
    String describe(ScheduleChangeDetail detail) =>
        '${detail.label}: ${l10n.scheduleChangeBefore} ${detail.before}; '
        '${l10n.scheduleChangeAfter} ${detail.after}';
    final summary = [
      ...context,
      for (final detail in details) describe(detail),
      if (!single && details.isEmpty) l10n.scheduleChangeDetailsUnavailable,
    ].join(' · ');
    return ScheduleChangePresentation._(
      subject: subject,
      title: title,
      effectiveKind: effectiveKind,
      details: details,
      context: context,
      summary: summary,
      isSingleSnapshot: single,
    );
  }

  final String subject;
  final String title;
  final ScheduleChangeKind effectiveKind;
  final List<ScheduleChangeDetail> details;
  final List<String> context;
  final String summary;
  final bool isSingleSnapshot;
}
