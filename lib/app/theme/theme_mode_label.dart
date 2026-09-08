import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

extension AdaptiveThemeModeLabel on AdaptiveThemeMode {
  String label(AppLocalizations l10n) => switch (this) {
    AdaptiveThemeMode.light => l10n.settingsThemeLight,
    AdaptiveThemeMode.dark => l10n.settingsThemeDark,
    AdaptiveThemeMode.system => l10n.settingsThemeAuto,
  };
}
