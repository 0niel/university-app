import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_news/l10n/localizations.dart';
import 'package:neon_news/src/blocs/news.dart';
import 'package:neon_news/src/options.dart';
import 'package:neon_news/src/pages/main.dart';
import 'package:neon_news/src/routes.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/news.dart' as news;
import 'package:nextcloud/nextcloud.dart';
import 'package:rxdart/rxdart.dart';

class NewsApp extends AppImplementation<NewsBloc, NewsOptions> {
  NewsApp();

  @override
  final String id = AppIDs.news;

  @override
  final LocalizationsDelegate<NewsLocalizations> localizationsDelegate = NewsLocalizations.delegate;

  @override
  final List<Locale> supportedLocales = NewsLocalizations.supportedLocales;

  @override
  late final NewsOptions options = NewsOptions(storage);

  @override
  NewsBloc buildBloc(Account account) => NewsBloc(
        options,
        account,
      );

  @override
  final Widget page = const NewsMainPage();

  @override
  final RouteBase route = $newsAppRoute;

  @override
  BehaviorSubject<int> getUnreadCounter(NewsBloc bloc) => bloc.unreadCounter;

  @override
  Future<VersionCheck> getVersionCheck(
    Account account,
    core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data capabilities,
  ) =>
      account.client.news.getVersionCheck();
}
