import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_notifications/l10n/localizations.dart';
import 'package:neon_notifications/src/blocs/notifications.dart';
import 'package:neon_notifications/src/options.dart';
import 'package:neon_notifications/src/pages/main.dart';
import 'package:neon_notifications/src/routes.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsApp extends AppImplementation<NotificationsBloc, NotificationsOptions>
    implements
        // ignore: avoid_implementing_value_types
        NotificationsAppInterface<NotificationsBloc, NotificationsOptions> {
  NotificationsApp();

  @override
  final String id = AppIDs.notifications;

  @override
  final LocalizationsDelegate<NotificationsLocalizations> localizationsDelegate = NotificationsLocalizations.delegate;

  @override
  final List<Locale> supportedLocales = NotificationsLocalizations.supportedLocales;

  @override
  late final NotificationsOptions options = NotificationsOptions(storage);

  @override
  NotificationsBloc buildBloc(Account account) => NotificationsBloc(
        options,
        account,
      );

  @override
  final Widget page = const NotificationsMainPage();

  @override
  final RouteBase route = $notificationsAppRoute;

  @override
  BehaviorSubject<int> getUnreadCounter(NotificationsBloc bloc) => bloc.unreadCounter;
}
