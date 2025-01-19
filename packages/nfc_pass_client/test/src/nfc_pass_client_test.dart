// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';

void main() {
  group('NfcPassClient', () {
    test('can be instantiated', () {
      expect(NfcPassClient(), isNotNull);
    });
  });
}
