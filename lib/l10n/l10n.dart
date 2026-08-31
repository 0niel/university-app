import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
