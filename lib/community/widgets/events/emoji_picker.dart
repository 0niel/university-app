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
    final colors = context.ninja;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final emoji in emojis)
          Semantics(
            button: true,
            selected: selected == emoji,
            label: emoji,
            child: AppPressable(
              onTap: () => onSelected(emoji),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == emoji ? colors.brandTint : colors.surface,
                  borderRadius: BorderRadius.circular(NinjaRadius.control),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
          ),
      ],
    );
  }
}
