part of '../settings_appearance.dart';

const List<LessonType> _kLessonTypes = LessonType.values;

class _LessonTypeColors extends StatelessWidget {
  const _LessonTypeColors();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<UiPreferencesCubit>().state;
    final palette = LessonTypePalette.resolve(
      context.colors,
      state.lessonTypeColors,
    );
    return SettingsRow(
      title: l10n.settingsLessonColors,
      subtitle: l10n.settingsLessonColorsSubtitle,
      lineIcon: AppLineIcon.palette,
      trailing: _LessonColorPreview(
        colors: [
          for (final type in _kLessonTypes.take(5)) Color(palette[type.name]!),
        ],
      ),
      onTap: () => _showLessonColorsSheet(context),
    );
  }
}
