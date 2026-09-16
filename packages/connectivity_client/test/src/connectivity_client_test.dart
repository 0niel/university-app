import 'package:connectivity_client/connectivity_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('ConnectivityClient', () {
    late Connectivity connectivity;
    late ConnectivityClient client;

    setUp(() {
      connectivity = _MockConnectivity();
      client = ConnectivityClient(connectivity: connectivity);
    });

    test('returns true on Wi-Fi', () async {
      when(connectivity.checkConnectivity).thenAnswer(
        (_) => Future.value([ConnectivityResult.wifi]),
      );
      expect(await client.hasWifiOrEthernet(), isTrue);
    });

    test('returns false on mobile data', () async {
      when(connectivity.checkConnectivity).thenAnswer(
        (_) => Future.value([ConnectivityResult.mobile]),
      );
      expect(await client.hasWifiOrEthernet(), isFalse);
    });

    test('detects an active VPN next to the underlying transport', () async {
      when(connectivity.checkConnectivity).thenAnswer(
        (_) => Future.value([ConnectivityResult.wifi, ConnectivityResult.vpn]),
      );
      expect(await client.hasVpn(), isTrue);
      when(connectivity.checkConnectivity).thenAnswer(
        (_) => Future.value([ConnectivityResult.wifi]),
      );
      expect(await client.hasVpn(), isFalse);
    });

    test('hasVpn throws ConnectivityCheckFailure on platform error', () async {
      when(connectivity.checkConnectivity).thenThrow(Exception('boom'));
      await expectLater(
        client.hasVpn(),
        throwsA(isA<ConnectivityCheckFailure>()),
      );
    });

    test('throws ConnectivityCheckFailure on platform error', () async {
      when(connectivity.checkConnectivity).thenThrow(Exception('boom'));
      await expectLater(
        client.hasWifiOrEthernet(),
        throwsA(isA<ConnectivityCheckFailure>()),
      );
    });
  });
}
