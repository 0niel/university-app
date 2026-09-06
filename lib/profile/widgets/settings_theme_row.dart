import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/app/theme/theme_mode_label.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

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
    final l10n = context.l10n;
    final manager = AdaptiveTheme.maybeOf(context);
    final current = mode ?? manager?.mode ?? AdaptiveThemeMode.system;
    final onModeSelected = onChanged ?? manager?.setThemeMode;
    return Padding(
      padding: compact ? EdgeInsets.zero : const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.settingsTheme,
            style: AppText.sans(
              15,
              FontWeight.w600,
              height: 4 / 3,
            ).copyWith(color: context.colors.ink),
          ),
          const SizedBox(height: AppSpacing.md),
          AppSegmentedControl<AdaptiveThemeMode>(
            value: current,
            onChanged: onModeSelected == null
                ? null
                : (mode) {
                    if (mode != current) onModeSelected(mode);
                  },
            options: [
              for (final mode in AdaptiveThemeMode.values)
                AppSegmentedOption(value: mode, label: mode.label(l10n)),
            ],
          ),
        ],
      ),
    );
  }
}
