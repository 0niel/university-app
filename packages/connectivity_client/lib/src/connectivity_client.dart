import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityClient {
  ConnectivityClient({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> hasWifiOrEthernet() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ConnectivityCheckFailure(error), stackTrace);
    }
  }

  /// Whether a VPN transport is active. The OS reports it alongside the
  /// underlying Wi-Fi or mobile transport.
  Future<bool> hasVpn() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.vpn);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ConnectivityCheckFailure(error), stackTrace);
    }
  }
}

class ConnectivityCheckFailure implements Exception {
  const ConnectivityCheckFailure(this.error);

  final Object error;
}
