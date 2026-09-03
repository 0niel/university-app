import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class OnboardingThemeCard extends StatelessWidget {
  const OnboardingThemeCard({super.key, this.onChanged});

  final ValueChanged<AdaptiveThemeMode>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final manager = AdaptiveTheme.maybeOf(context);
    final current = switch (manager?.mode) {
      AdaptiveThemeMode.light => AdaptiveThemeMode.light,
      AdaptiveThemeMode.dark => AdaptiveThemeMode.dark,
      _ =>
        Theme.of(context).brightness == Brightness.dark
            ? AdaptiveThemeMode.dark
            : AdaptiveThemeMode.light,
    };
    final onModeSelected = onChanged ?? manager?.setThemeMode;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsTheme,
            style: AppText.headline.copyWith(color: colors.ink),
          ),
          const SizedBox(height: 12),
          AppSegmentedControl<AdaptiveThemeMode>(
            key: const Key('onboarding_themeSegmented'),
            value: current,
            onChanged: onModeSelected == null
                ? null
                : (mode) {
                    if (mode != current) onModeSelected(mode);
                  },
            options: [
              AppSegmentedOption(
                value: AdaptiveThemeMode.light,
                label: l10n.settingsThemeLight,
              ),
              AppSegmentedOption(
                value: AdaptiveThemeMode.dark,
                label: l10n.settingsThemeDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
