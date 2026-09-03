import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'theme_mode_icon.dart';

class SettingsThemeRow extends StatelessWidget {
  const SettingsThemeRow({
    super.key,
    this.mode,
    this.onChanged,
    this.compact = false,
  });

  final AdaptiveThemeMode? mode;
  final ValueChanged<AdaptiveThemeMode>? onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final manager = AdaptiveTheme.maybeOf(context);
    final current = mode ?? manager?.mode ?? AdaptiveThemeMode.system;
    final onModeSelected = onChanged ?? manager?.setThemeMode;
    return Padding(
      padding: compact ? EdgeInsets.zero : const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.settingsTheme,
                  style: AppText.sans(
                    15,
                    FontWeight.w600,
                    height: 4 / 3,
                  ).copyWith(color: context.colors.ink),
                ),
              ),
              if (!compact)
                AppButton.text(
                  label: context.l10n.settingsThemeAuto,
                  size: AppButtonSize.small,
                  onPressed: onModeSelected == null
                      ? null
                      : () => _showThemeSheet(
                          context,
                          current: current,
                          onSelected: onModeSelected,
                        ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppSegmentedControl<AdaptiveThemeMode>(
            value: current == AdaptiveThemeMode.system
                ? (context.colors.isDark
                      ? AdaptiveThemeMode.dark
                      : AdaptiveThemeMode.light)
                : current,
            onChanged: onModeSelected,
            options: [
              for (final mode in [
                AdaptiveThemeMode.light,
                AdaptiveThemeMode.dark,
              ])
                AppSegmentedOption(
                  value: mode,
                  label: _themeLabel(context, mode),
                ),
            ],
          ),
        ],
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
