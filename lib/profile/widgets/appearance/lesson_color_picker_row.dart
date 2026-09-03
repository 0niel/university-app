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
          style: AppText.headline.copyWith(color: context.colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
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
                    dimension: AppControlSize.iconButton,
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
                                color: Color(value).computeLuminance() > 0.45
                                    ? context.colors.ink
                                    : context.colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            AppButton.secondary(
              key: ValueKey('lesson-color-custom-${type.name}'),
              label: l10n.settingsColorCustom,
              size: AppButtonSize.small,
              icon: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Color(selected),
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.line),
                ),
              ),
              onPressed: () => _openCustom(context, label),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openCustom(BuildContext context, String label) async {
    final value = await showAppSheet<int>(
      context,
      title: label,
      subtitle: context.l10n.settingsColorCustom,
      child: LessonColorEditor(
        color: Color(selected),
        onSaved: (color) =>
            Navigator.of(context, rootNavigator: true).pop(color),
      ),
    );
    if (value != null) onSelected(value);
  }
}
