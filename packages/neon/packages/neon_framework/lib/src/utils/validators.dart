import 'package:flutter/widgets.dart';
import 'package:neon_framework/l10n/localizations.dart';

/// Validates whether the given [input] is a valid HTTP(S) URL.
///
/// Set [httpsOnly] if you want to only allow HTTPS URLs.
/// Returns `null` if the URL is valid or a localized error message if not.
String? validateHttpUrl(
  BuildContext context,
  String? input, {
  bool httpsOnly = false,
}) {
  if (input == null || input.isEmpty) {
    return NeonLocalizations.of(context).errorInvalidURL;
  }
  final uri = Uri.tryParse(input);

  if (uri != null) {
    if (uri.isScheme('https')) {
      return null;
    }
    if (uri.isScheme('http') && !httpsOnly) {
      // TODO: Maybe make a better error message for http URLs if only https is allowed
      return null;
    }
  }

  return NeonLocalizations.of(context).errorInvalidURL;
}

/// Validates that the given [input] is neither null nor empty.
///
/// Returns `null` if not empty or a localized error message if empty.
String? validateNotEmpty(BuildContext context, String? input) {
  if (input == null || input.isEmpty) {
    return NeonLocalizations.of(context).errorEmptyField;
  }

  return null;
}
