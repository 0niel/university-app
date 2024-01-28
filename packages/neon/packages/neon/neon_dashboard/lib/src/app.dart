import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon_dashboard/l10n/localizations.dart';
import 'package:neon_dashboard/src/blocs/dashboard.dart';
import 'package:neon_dashboard/src/options.dart';
import 'package:neon_dashboard/src/pages/main.dart';
import 'package:neon_dashboard/src/routes.dart';
import 'package:neon_framework/models.dart';
import 'package:nextcloud/nextcloud.dart';

/// Implementation of the server `dashboard` app.
class DashboardApp extends AppImplementation<DashboardBloc, DashboardOptions> {
  /// Creates a new Dashboard app implementation instance.
  DashboardApp();

  @override
  final String id = AppIDs.dashboard;

  @override
  final LocalizationsDelegate<DashboardLocalizations> localizationsDelegate = DashboardLocalizations.delegate;

  @override
  final List<Locale> supportedLocales = DashboardLocalizations.supportedLocales;

  @override
  late final DashboardOptions options = DashboardOptions(storage);

  @override
  DashboardBloc buildBloc(Account account) => DashboardBloc(account);

  @override
  final Widget page = const DashboardMainPage();

  @override
  final RouteBase route = $dashboardAppRoute;
}
