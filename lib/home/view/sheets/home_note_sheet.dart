import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/lesson_comments/lesson_comments_cubit.dart';
import 'package:rtu_mirea_app/schedule/models/lesson_comment.dart';

Future<void> showHomeNoteSheet(
  BuildContext context,
  HomeLessonEntry entry,
) async {
  final cubit = context.read<LessonCommentsCubit>();
  final date = DateUtils.dateOnly(entry.start);
  final existing = cubit.state.comments
      .where(
        (comment) =>
            comment.subjectName == entry.lesson.subject &&
            DateUtils.isSameDay(comment.lessonDate, date) &&
            comment.lessonBells == entry.lesson.lessonBells,
      )
      .firstOrNull;
  await showAppSheet<void>(
    context,
    title: context.l10n.lessonDetailsNoteTitle,
    subtitle: entry.lesson.subject,
    child: HomeNoteSheet(
      initialText: existing?.text ?? '',
      onSave: (text) {
        cubit.setLessonComment(
          LessonComment(
            subjectName: entry.lesson.subject,
            lessonDate: date,
            lessonBells: entry.lesson.lessonBells,
            text: text,
            isSharedWithGroup: existing?.isSharedWithGroup ?? false,
          ),
        );
      },
    ),
  );
}

class HomeNoteSheet extends StatefulWidget {
  const HomeNoteSheet({
    required this.initialText,
    required this.onSave,
    super.key,
  });
  final String initialText;
  final ValueChanged<String> onSave;

  @override
  State<HomeNoteSheet> createState() => _HomeNoteSheetState();
}

class _HomeNoteSheetState extends State<HomeNoteSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppInputField.multiline(
        key: const Key('home-note-input'),
        controller: _controller,
        placeholder: context.l10n.lessonDetailsNoteHint,
        autofocus: true,
        minLines: 4,
        maxLines: 8,
        maxLength: 2000,
        fillColor: context.colors.surface,
      ),
      const SizedBox(height: 18),
      AppButton.primary(
        key: const Key('home-note-save'),
        label: context.l10n.save,
        size: AppButtonSize.large,
        expanded: true,
        onPressed: () {
          widget.onSave(_controller.text.trim());
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
