import 'package:flutter/widgets.dart';

abstract interface class ModuleHost {
  String get organizationId;
  String get accountId;
  bool get digitalPassAvailable;
  Future<void> Function(String cookie)? get setDigitalPassSession;
  Future<void> Function()? get clearDigitalPassSession;

  Future<String?> readSecure(String key);
  Future<void> writeSecure(String key, String value);
  Future<void> deleteSecure(String key);
  Future<void> openDigitalPass(BuildContext context);
}
