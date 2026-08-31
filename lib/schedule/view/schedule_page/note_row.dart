part of '../schedule_page.dart';

class _NoteRow extends StatelessWidget {
  const _NoteRow({
    required this.text,
    this.dimmed = false,
    this.foreground,
  });

  final String text;
  final bool dimmed;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    return _LessonExtraRow(
      text: text,
      dimmed: dimmed,
      foreground: foreground,
    );
  }
}
