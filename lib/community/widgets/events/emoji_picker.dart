part of '../create_event_sheet.dart';

class _EmojiPicker extends StatelessWidget {
  const _EmojiPicker({
    required this.emojis,
    required this.selected,
    required this.onSelected,
  });

  final List<String> emojis;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final emoji in emojis)
          Semantics(
            button: true,
            selected: selected == emoji,
            label: emoji,
            child: AppPressable(
              onTap: () => onSelected(emoji),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.field + 3),
                  border: selected == emoji
                      ? Border.all(color: colors.accent, width: 2)
                      : null,
                ),
                padding: const EdgeInsets.all(2),
                child: EmojiTile(emoji: emoji),
              ),
            ),
          ),
      ],
    );
  }
}
