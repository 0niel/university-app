import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/app/theme/theme_mode_label.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class OnboardingThemeCard extends StatelessWidget {
  const OnboardingThemeCard({super.key, this.mode, this.onChanged});

  final AdaptiveThemeMode? mode;
  final ValueChanged<AdaptiveThemeMode>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final manager = AdaptiveTheme.maybeOf(context);
    final current = mode ?? manager?.mode ?? AdaptiveThemeMode.system;
    final onModeSelected = onChanged ?? manager?.setThemeMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsTheme,
          style: AppText.headline.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 12),
        Row(
          key: const Key('onboarding_themeChoices'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final mode in AdaptiveThemeMode.values) ...[
              if (mode != AdaptiveThemeMode.values.first)
                const SizedBox(width: 10),
              Expanded(
                child: AppThemePreview(
                  label: mode.label(l10n),
                  selected: mode == current,
                  dark: mode == AdaptiveThemeMode.dark,
                  system: mode == AdaptiveThemeMode.system,
                  onPressed: onModeSelected == null
                      ? null
                      : () {
                          if (mode != current) onModeSelected(mode);
                        },
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
