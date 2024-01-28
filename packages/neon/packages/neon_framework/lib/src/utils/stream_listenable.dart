import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// Listenable Stream
///
/// A class that implements [Listenable] for a stream.
/// Objects need to be manually disposed.
class StreamListenable extends ChangeNotifier {
  /// Listenable Stream
  StreamListenable(Stream<dynamic> stream) {
    if (stream is! BehaviorSubject) {
      notifyListeners();
    }

    _addSubscription(stream);
  }

  /// Listenable for multiple Streams.
  ///
  /// Notifies it's listeners on every event emitted by any of the streams.
  StreamListenable.multiListenable(Iterable<Stream<dynamic>> streams) {
    streams.forEach(_addSubscription);
  }

  void _addSubscription(Stream<dynamic> stream) {
    _subscriptions.add(
      stream.asBroadcastStream().listen((_) {
        notifyListeners();
      }),
    );
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }

    super.dispose();
  }
}
