import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> simulatePlatformCall(
  String channel,
  String method, [
  dynamic arguments,
]) async {
  const standardMethod = StandardMethodCodec();

  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(
    channel,
    standardMethod.encodeMethodCall(MethodCall(method, arguments)),
    null,
  );
}
