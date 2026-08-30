part of 'mini_app_submit_page.dart';

class _ScreenEditor extends StatelessWidget {
  const _ScreenEditor({
    required this.draft,
    required this.isEntry,
    required this.onPreview,
    this.onRemove,
  });

  final ScreenDraft draft;
  final bool isEntry;
  final VoidCallback onPreview;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: NinjaInput(
                controller: draft.pathController,
                readOnly: isEntry,
                clearable: !isEntry,
                placeholder: l10n.miniAppsSubmitScreenPathHint,
                textStyle: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            NinjaIconButton(
              icon: const AppLineIconWidget(.view, size: 20),
              tooltip: l10n.miniAppsSubmitPreview,
              onPressed: onPreview,
            ),
            if (onRemove case final removeCallback?)
              NinjaIconButton(
                icon: const AppLineIconWidget(.close, size: 20),
                tooltip: l10n.miniAppsSubmitRemoveScreen,
                onPressed: removeCallback,
              ),
          ],
        ),
        NinjaInput(
          controller: draft.jsonController,
          maxLines: 10,
          clearable: false,
          keyboardType: TextInputType.multiline,
          placeholder: l10n.miniAppsSubmitJsonHint,
          textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 12.5),
        ),
      ],
    );
  }
}
