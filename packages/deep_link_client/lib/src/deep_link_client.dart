import 'dart:async';

import 'package:app_links/app_links.dart';

/// {@template deep_link_client}
/// A client for handling deep links.
/// {@endtemplate}
class DeepLinkClient {
  /// {@macro deep_link_client}
  DeepLinkClient({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks() {
    _appLinks.uriLinkStream.first.then((uri) {
      if (!_initialLinkCompleter.isCompleted) {
        _initialLinkCompleter.complete(uri);
      }
    }).catchError((Object error, StackTrace stackTrace) {
      if (!_initialLinkCompleter.isCompleted) {
        _initialLinkCompleter.completeError(error, stackTrace);
      }
    });
  }
  final AppLinks _appLinks;
  final Completer<Uri?> _initialLinkCompleter = Completer<Uri?>();

  /// A stream of deep links that are received while the app is running.
  Stream<Uri> get deepLinkStream => _appLinks.uriLinkStream;

  /// Return the initial link that was used to open the app.
  Future<Uri?> getInitialLink() async {
    return _initialLinkCompleter.future;
  }
}
