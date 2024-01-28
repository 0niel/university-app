import 'dart:ui';

import 'package:intl/intl_standalone.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';

/// Loads the [NeonLocalizations] for the system [Locale].
///
/// When the system locale is not supported [fallbackLocale] will be used.
@internal
Future<NeonLocalizations> appLocalizationsFromSystem([Locale fallbackLocale = const Locale('en', 'US')]) async {
  final systemLocale = await findSystemLocale();
  final parts = systemLocale.split('_').map((a) => a.split('.')).expand((e) => e).toList();
  final locale = Locale(parts[0], parts.length > 1 ? parts[1] : null);

  final isSupported = NeonLocalizations.delegate.isSupported(locale);

  return NeonLocalizations.delegate.load(isSupported ? locale : fallbackLocale);
}
