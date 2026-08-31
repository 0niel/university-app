part of '../schedule_details_page.dart';

mixin _LessonNoteActions on State<ScheduleDetailsPage> {
  LessonComment? get _comment {
    final comments = context.read<LessonCommentsCubit>().state.comments;
    return comments.firstWhereOrNull(
      (comment) =>
          comment.subjectName == widget.lesson.subject &&
          widget.lesson.dates.any(
            (date) => _sameDate(date, widget.selectedDate),
          ) &&
          comment.lessonBells == widget.lesson.lessonBells,
    );
  }

  void _openNoteSheet() {
    final locale = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat('d MMMM', locale).format(widget.selectedDate);
    final room = widget.lesson.classrooms.firstOrNull?.name;
    final wasShared = _comment?.isSharedWithGroup ?? false;

    unawaited(
      showAppSheet<void>(
        context,
        showGrabber: false,
        scrollable: false,
        contentPadding: EdgeInsets.zero,
        child: _LessonNoteEditorSheet(
          initialText: _comment?.text ?? '',
          initialShared: wasShared,
          subtitle: '${widget.lesson.subject} · $dateLabel',
          accent: context.ninja.brandInk,
          room: room,
          groupName: _userGroupName(),
          onChanged: ({required text, required shared}) =>
              _saveNote(text, shared, publish: false),
          onDone: ({required text, required shared}) =>
              _saveNote(text, shared, publish: shared && !wasShared),
        ),
      ),
    );
  }

  String? _userGroupName() {
    final selected = context.read<ScheduleBloc>().state.selectedSchedule;
    return selected is SelectedGroupSchedule ? selected.group.name : null;
  }

  void _saveNote(String text, bool shared, {required bool publish}) {
    context.read<LessonCommentsCubit>().setLessonComment(
      LessonComment(
        subjectName: widget.lesson.subject,
        lessonDate: widget.selectedDate,
        lessonBells: widget.lesson.lessonBells,
        text: text,
        isSharedWithGroup: shared,
      ),
    );
    if (publish && text.trim().isNotEmpty) {
      unawaited(_publishNoteToGroup(text));
    }
  }

  Future<void> _publishNoteToGroup(String text) async {
    try {
      final repository = context.read<CampusRepository>();
      final title = widget.lesson.subject;
      final id = await repository.createGroupNote(title);
      await repository.saveGroupNote(
        id: id,
        title: title,
        content: text,
        expectedRevision: 0,
      );
      if (mounted) {
        showNinjaToast(context, message: context.l10n.noteSharedToGroup);
      }
    } on Exception catch (e, st) {
      log(
        'Failed to publish note to group',
        error: e,
        stackTrace: st,
        name: 'ScheduleDetailsPage',
      );
    }
  }
}
