part of '../settings_appearance.dart';

const _kLessonColorPalette = [
  0xFF087F5B,
  0xFF2F7AFF,
  0xFF8B5CF6,
  0xFFDB8B00,
  0xFFE5484D,
  0xFF74747D,
];

Future<void> _showLessonColorsSheet(BuildContext context) {
  final cubit = context.read<UiPreferencesCubit>();
  return showAppSheet<void>(
    context,
    title: context.l10n.settingsLessonColors,
    subtitle: context.l10n.settingsLessonColorsSubtitle,
    child: BlocProvider.value(
      value: cubit,
      child: const _LessonTypesColorPicker(),
    ),
  );
}

class _LessonTypesColorPicker extends StatelessWidget {
  const _LessonTypesColorPicker();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UiPreferencesCubit>();
    return BlocBuilder<UiPreferencesCubit, UiPreferencesState>(
      builder: (context, state) => Column(
        crossAxisAlignment: .stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AppButton.text(
              label: context.l10n.reset,
              size: AppButtonSize.small,
              onPressed: cubit.resetLessonTypeColors,
            ),
          ),
          for (var index = 0; index < _kLessonTypes.length; index++)
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 18),
              child: _LessonColorPickerRow(
                type: _kLessonTypes[index],
                selected: state.lessonTypeColor(_kLessonTypes[index].name),
                onSelected: (value) =>
                    cubit.setLessonTypeColor(_kLessonTypes[index].name, value),
              ),
            ),
        ],
      ),
    );
  }
}
