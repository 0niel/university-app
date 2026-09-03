part of 'teacher_profile_page.dart';

class _ReviewSheet extends StatefulWidget {
  const _ReviewSheet({
    required this.repository,
    required this.teacherName,
    this.current,
  });

  final CampusRepository repository;
  final String teacherName;
  final TeacherReview? current;

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  late final TextEditingController _body = TextEditingController(
    text: widget.current?.body ?? '',
  );
  late int _clarity = widget.current?.clarity ?? 4;
  late int _loyalty = widget.current?.loyalty ?? 4;
  late int _usefulness = widget.current?.usefulness ?? 4;
  bool _anonymous = false;
  bool _saving = false;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.repository.upsertTeacherReview(
        teacherName: widget.teacherName,
        clarity: _clarity,
        loyalty: _loyalty,
        usefulness: _usefulness,
        body: _body.text.trim(),
        isAnonymous: _anonymous,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Exception catch (e, st) {
      log(
        'Failed to save teacher review',
        error: e,
        stackTrace: st,
        name: 'TeacherProfilePage',
      );
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        _StarsRow(
          label: context.l10n.teacherProfileClarity,
          value: _clarity,
          onChanged: (v) => setState(() => _clarity = v),
        ),
        _StarsRow(
          label: context.l10n.teacherProfileLoyalty,
          value: _loyalty,
          onChanged: (v) => setState(() => _loyalty = v),
        ),
        _StarsRow(
          label: context.l10n.teacherProfileUsefulness,
          value: _usefulness,
          onChanged: (v) => setState(() => _usefulness = v),
        ),
        const SizedBox(height: AppSpacing.md),
        AppInputField.multiline(
          controller: _body,
          minLines: 2,
          maxLines: 4,
          placeholder: context.l10n.teacherProfileReviewHint,
        ),
        const SizedBox(height: AppSpacing.gap),
        AppPressable(
          onTap: () => setState(() => _anonymous = !_anonymous),
          semanticsLabel: context.l10n.teacherProfileAnonymous,
          semanticsToggled: _anonymous,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppControlSize.touchTarget,
            ),
            padding: const .symmetric(
              horizontal: AppSpacing.sectionGap,
              vertical: AppSpacing.xsm,
            ),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: .circular(AppRadius.card),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.teacherProfileAnonymous,
                    style: AppText.body.copyWith(color: colors.ink),
                  ),
                ),
                AppSwitch(
                  value: _anonymous,
                  onChanged: (value) => setState(() => _anonymous = value),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: _saving
              ? context.l10n.teacherProfileSaving
              : context.l10n.teacherProfilePublish,
          expanded: true,
          size: .large,
          onPressed: _saving ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}
