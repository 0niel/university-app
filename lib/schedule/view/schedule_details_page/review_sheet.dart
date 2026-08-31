part of '../schedule_details_page.dart';

class _ReviewSheet extends StatefulWidget {
  const _ReviewSheet({
    required this.lesson,
    required this.selectedDate,
    required this.lessonNumber,
  });
  final LessonSchedulePart lesson;
  final DateTime selectedDate;
  final int lessonNumber;
  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  late final TextEditingController _controller;
  var _anonymous = false;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);
    try {
      await context.read<ScheduleRepository>().upsertLessonReview(
        UpsertLessonReviewRequest(
          subjectName: widget.lesson.subject,
          lessonDate: widget.selectedDate,
          lessonBellsNumber: widget.lessonNumber,
          lessonUid: widget.lesson.uid,
          body: text,
          isAnonymous: _anonymous,
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Exception catch (e, st) {
      log(
        'upsertLessonReview failed',
        error: e,
        stackTrace: st,
        name: '_ReviewSheetState',
      );
      if (!mounted) return;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsSignInReview,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: .min,
    crossAxisAlignment: .start,
    children: [
      NinjaInput.multiline(
        controller: _controller,
        maxLines: 5,
        maxLength: 800,
        placeholder: context.l10n.lessonDetailsReviewHint,
      ),
      SettingsToggleRow(
        label: context.l10n.lessonDetailsAnonymous,
        value: _anonymous,
        onChanged: (value) => setState(() => _anonymous = value),
      ),
      const SizedBox(height: 10),
      NinjaButton.primary(
        label: _saving
            ? context.l10n.lessonDetailsSaving
            : context.l10n.lessonDetailsSubmitReview,
        expanded: true,
        size: .large,
        icon: const AppLineIconWidget(AppLineIcon.message),
        onPressed: _saving ? null : () => unawaited(_save()),
      ),
    ],
  );
}
