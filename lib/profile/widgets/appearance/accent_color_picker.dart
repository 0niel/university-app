part of '../settings_appearance.dart';

Future<void> _showAccentSheet(BuildContext context) {
  final themeCubit = context.read<ThemeCubit>();
  final profileCubit = context.read<ProfileCubit?>();
  return showAppSheet<void>(
    context,
    title: context.l10n.settingsAccent,
    subtitle: context.l10n.settingsAccentSubtitle,
    child: BlocProvider.value(
      value: themeCubit,
      child: _AccentColorPicker(
        onSelected: (scheme) {
          themeCubit.setColorScheme(scheme);
          if (profileCubit case final cubit?) {
            unawaited(
              cubit.updateSettings(
                cubit.state.settings.copyWith(accentColor: scheme.name),
              ),
            );
          }
        },
      ),
    ),
  );
}

class _AccentColorPicker extends StatelessWidget {
  const _AccentColorPicker({required this.onSelected});

  final ValueChanged<AppColorScheme> onSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) =>
          previous.colorScheme != current.colorScheme,
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final scheme in AppColorSchemes.selectable)
            AppRadioRow(
              title: _accentLabel(context, scheme),
              selected: state.colorScheme == scheme,
              leading: _AccentChoiceSwatch(scheme: scheme),
              onTap: () {
                if (state.colorScheme != scheme) onSelected(scheme);
              },
            ),
        ],
      ),
    );
  }
}

String _accentLabel(BuildContext context, AppColorScheme scheme) {
  final l10n = context.l10n;
  return switch (scheme) {
    .blue => l10n.settingsAccentBlue,
    .violet => l10n.settingsAccentViolet,
    .yellow => l10n.settingsAccentYellow,
    .red => l10n.settingsAccentRed,
    .green => l10n.settingsAccentGreen,
  };
}
