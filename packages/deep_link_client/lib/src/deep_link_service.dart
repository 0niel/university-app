import 'dart:async';

import 'package:deep_link_client/src/deep_link_client.dart';
import 'package:deep_link_client/src/deep_link_client_failure.dart';
import 'package:rxdart/rxdart.dart';

class DeepLinkService {
  DeepLinkService({required DeepLinkClient deepLinkClient})
    : _deepLinkClient = deepLinkClient,
      _deepLinkStream = BehaviorSubject<Uri>() {
    unawaited(_getInitialLink());
    _deepLinkSubscription = _deepLinkClient.deepLinkStream.listen(
      _onAppLink,
      onError: _handleError,
    );
  }

  final DeepLinkClient _deepLinkClient;
  final BehaviorSubject<Uri> _deepLinkStream;
  late final StreamSubscription<Uri> _deepLinkSubscription;

  Stream<Uri> get deepLinkStream => _deepLinkStream;

  Future<void> close() async {
    await _deepLinkSubscription.cancel();
    unawaited(_deepLinkStream.close());
  }

  Future<void> _getInitialLink() async {
    try {
      final deepLink = await _deepLinkClient.getInitialLink();
      if (deepLink != null) {
        _onAppLink(deepLink);
      }
    } on Object catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  void _onAppLink(Uri deepLink) {
    _deepLinkStream.add(deepLink);
  }

  void _handleError(Object error, StackTrace stackTrace) {
    _deepLinkStream.addError(DeepLinkClientFailure(error), stackTrace);
  }
}
