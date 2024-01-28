import 'package:flutter/material.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_notes/l10n/localizations.dart';
import 'package:nextcloud/nextcloud.dart';

void handleNotesException(BuildContext context, Object error) {
  if (error is DynamiteStatusCodeException && error.statusCode == 412) {
    NeonError.showSnackbar(context, NotesLocalizations.of(context).errorChangedOnServer);
  } else {
    NeonError.showSnackbar(context, error);
  }
}
