part of 'mini_app_submit_page.dart';

class _MetadataSection extends StatelessWidget {
  const _MetadataSection({
    required this.nameController,
    required this.slugController,
    required this.descriptionController,
    required this.emojiController,
    required this.onNameChanged,
    required this.onSlugEdited,
  });

  final TextEditingController nameController;
  final TextEditingController slugController;
  final TextEditingController descriptionController;
  final TextEditingController emojiController;
  final void Function(String name) onNameChanged;
  final VoidCallback onSlugEdited;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        Row(
          spacing: 12,
          children: [
            SizedBox(
              width: 72,
              child: NinjaInput(
                controller: emojiController,
                maxLength: 2,
                clearable: false,
                textAlign: TextAlign.center,
                textStyle: const TextStyle(fontSize: 26),
              ),
            ),
            Expanded(
              child: NinjaInput(
                controller: nameController,
                maxLength: 40,
                onChanged: onNameChanged,
                placeholder: l10n.miniAppsSubmitNameHint,
              ),
            ),
          ],
        ),
        NinjaInput(
          controller: slugController,
          maxLength: 40,
          clearable: false,
          onChanged: (_) => onSlugEdited(),
          placeholder: l10n.miniAppsSubmitSlugHint,
          leadingIcon: Text(
            'apps/',
            style: NinjaText.body.copyWith(color: colors.muted),
          ),
        ),
        NinjaInput.multiline(
          controller: descriptionController,
          maxLength: 200,
          minLines: 1,
          maxLines: 2,
          placeholder: l10n.miniAppsSubmitDescriptionHint,
        ),
      ],
    );
  }
}
