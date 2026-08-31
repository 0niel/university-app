part of '../settings_appearance.dart';

class _AccentColorSetting extends StatelessWidget {
  const _AccentColorSetting();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) =>
          previous.colorScheme != current.colorScheme,
      builder: (context, state) => SettingsRow(
        title: context.l10n.settingsAccent,
        subtitle: context.l10n.settingsAccentSubtitle,
        lineIcon: AppLineIcon.spark,
        trailing: _AccentPreview(scheme: state.colorScheme),
        onTap: () => _showAccentSheet(context),
      ),
    );
  }
}
