import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// The default hosts to ping to check for internet connection.
final List<String> defaultHosts = [
  'ya.ru',
  'google.com',
];

/// A class that checks if the device is connected to the internet.
///
/// It uses the [Connectivity] plugin to check for internet connection.
/// It also uses the [InternetAddress.lookup] method to ping the default hosts.
///
/// If the device is connected to the internet, the [connectionChange] stream
/// will emit true.
class InternetConnectionChecker {
  static final InternetConnectionChecker _singleton = InternetConnectionChecker._internal();
  InternetConnectionChecker._internal();

  static InternetConnectionChecker getInstance() => _singleton;

  bool _hasConnection = false;

  /// The stream that emits whenever the connection status changes.
  StreamController connectionChangeController = StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = _hasConnection;

    bool currentConnectionStatus = false;

    for (var host in defaultHosts) {
      try {
        final result = await InternetAddress.lookup(host);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          currentConnectionStatus = true;
          break;
        }
      } on SocketException catch (_) {}
    }

    if (previousConnection != currentConnectionStatus) {
      _hasConnection = currentConnectionStatus;
      connectionChangeController.add(_hasConnection);
    }

    return _hasConnection;
  }

  Future<bool> get hasConnection async => await checkConnection();

  bool get lastKnownConnection => _hasConnection;
}
