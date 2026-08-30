import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAuthenticateActionParser
    implements StacActionParser<DeviceActionModel> {
  const StacAuthenticateActionParser();
  @override
  String get actionType => 'authenticate';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final ok =
        await MiniAppSessionStack.current?.host.authenticate(
          reason: stringOf(model, 'reason', 'Подтвердите личность'),
        ) ??
        false;
    final saveAs = stringOf(model, 'saveAs', 'authOk');
    if (!context.mounted) return null;
    return completeDeviceCapture(context, model, ok ? {saveAs: true} : null);
  }
}
