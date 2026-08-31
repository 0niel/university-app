import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';

part 'theme_mode_icon.dart';

class SettingsThemeRow extends StatelessWidget {
  const SettingsThemeRow({super.key, this.mode, this.onChanged});

  final AdaptiveThemeMode? mode;
  final ValueChanged<AdaptiveThemeMode>? onChanged;

  @override
  Widget build(BuildContext context) {
    final manager = AdaptiveTheme.maybeOf(context);
    final current = mode ?? manager?.mode ?? AdaptiveThemeMode.system;
    final onModeSelected = onChanged ?? manager?.setThemeMode;
    return SettingsRow(
      title: context.l10n.settingsTheme,
      value: _themeLabel(context, current),
      lineIcon: _themeIcon(current),
      onTap: onModeSelected == null
          ? null
          : () => _showThemeSheet(
              context,
              current: current,
              onSelected: onModeSelected,
            ),
    );
  }
}

Future<void> _showThemeSheet(
  BuildContext context, {
  required AdaptiveThemeMode current,
  required ValueChanged<AdaptiveThemeMode> onSelected,
}) {
  return showAppSheet<void>(
    context,
    title: context.l10n.settingsTheme,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final mode in AdaptiveThemeMode.values)
          AppRadioRow(
            title: _themeLabel(context, mode),
            selected: current == mode,
            leading: _ThemeModeIcon(mode: mode),
            onTap: () {
              if (current == mode) return;
              onSelected(mode);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
      ],
    ),
  );
}

AppLineIcon _themeIcon(AdaptiveThemeMode mode) => switch (mode) {
  AdaptiveThemeMode.light => AppLineIcon.spark,
  AdaptiveThemeMode.dark => AppLineIcon.moon,
  AdaptiveThemeMode.system => AppLineIcon.device,
};

String _themeLabel(BuildContext context, AdaptiveThemeMode mode) {
  final l10n = context.l10n;
  return switch (mode) {
    AdaptiveThemeMode.light => l10n.settingsThemeLight,
    AdaptiveThemeMode.dark => l10n.settingsThemeDark,
    AdaptiveThemeMode.system => l10n.settingsThemeAuto,
  };
}
