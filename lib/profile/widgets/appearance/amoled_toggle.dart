part of '../settings_appearance.dart';

class _AmoledToggle extends StatelessWidget {
  const _AmoledToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.isAmoled != current.isAmoled,
      builder: (context, state) => SettingsToggleRow(
        label: context.l10n.settingsAmoledTitle,
        sub: context.l10n.settingsAmoledSubtitle,
        lineIcon: AppLineIcon.moon,
        value: state.isAmoled,
        onChanged: (value) =>
            context.read<ThemeCubit>().setAmoled(enabled: value),
      ),
    );
  }
}
