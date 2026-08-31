part of 'mini_apps_moderation_page.dart';

Future<String?> _askNotes(BuildContext context, String title) {
  return showAppSheet<String>(
    context,
    title: title,
    child: const _NotesSheet(),
  );
}

class _NotesSheet extends StatefulWidget {
  const _NotesSheet();
  @override
  State<_NotesSheet> createState() => _NotesSheetState();
}

class _NotesSheetState extends State<_NotesSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      spacing: 12,
      children: [
        NinjaInput.multiline(
          controller: _controller,
          maxLines: 3,
          maxLength: 500,
          autofocus: true,
          placeholder: l10n.miniAppsModerationNotesHint,
        ),
        NinjaButton.primary(
          label: l10n.miniAppsModerationConfirm,
          expanded: true,
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
        ),
      ],
    );
  }
}
