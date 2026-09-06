import 'package:flutter/foundation.dart';

abstract final class NfcPassAvailability {
  static bool get isSupported => defaultTargetPlatform != TargetPlatform.iOS;
}
