part of '../settings_appearance.dart';

class _LessonColorPickerRow extends StatelessWidget {
  const _LessonColorPickerRow({
    required this.type,
    required this.selected,
    required this.onSelected,
  });

  final LessonType type;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = LessonCard.getLessonTypeName(l10n, type);
    final colorNames = {
      0xFF087F5B: l10n.settingsLessonColorGreen,
      0xFF2F7AFF: l10n.settingsLessonColorBlue,
      0xFF8B5CF6: l10n.settingsLessonColorViolet,
      0xFFDB8B00: l10n.settingsLessonColorAmber,
      0xFFE5484D: l10n.settingsLessonColorRed,
      0xFF74747D: l10n.settingsLessonColorGray,
    };
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          label,
          style: NinjaText.headline.copyWith(color: context.ninja.ink),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final value in _kLessonColorPalette)
              Semantics(
                button: true,
                selected: selected == value,
                label: '$label, ${colorNames[value] ?? ''}',
                child: AppPressable(
                  onTap: () => onSelected(value),
                  child: SizedBox.square(
                    dimension: NinjaMetrics.minTouchTarget,
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: .center,
                        decoration: BoxDecoration(
                          color: Color(value),
                          shape: BoxShape.circle,
                        ),
                        child: selected == value
                            ? NinjaCheckMark(
                                size: 13,
                                color: context.ninja.contrastForeground(
                                  Color(value),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
