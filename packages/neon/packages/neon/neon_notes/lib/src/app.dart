import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_notes/l10n/localizations.dart';
import 'package:neon_notes/src/blocs/notes.dart';
import 'package:neon_notes/src/options.dart';
import 'package:neon_notes/src/pages/main.dart';
import 'package:neon_notes/src/routes.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart' as notes;

class NotesApp extends AppImplementation<NotesBloc, NotesOptions> {
  NotesApp();

  @override
  final String id = AppIDs.notes;

  @override
  final List<Locale> supportedLocales = NotesLocalizations.supportedLocales;

  @override
  final LocalizationsDelegate<NotesLocalizations> localizationsDelegate = NotesLocalizations.delegate;

  @override
  late final NotesOptions options = NotesOptions(storage);

  @override
  NotesBloc buildBloc(Account account) => NotesBloc(
        options,
        account,
      );

  @override
  final Widget page = const NotesMainPage();

  @override
  final RouteBase route = $notesAppRoute;

  @override
  VersionCheck getVersionCheck(
    Account account,
    core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data capabilities,
  ) =>
      account.client.notes.getVersionCheck(capabilities);
}
