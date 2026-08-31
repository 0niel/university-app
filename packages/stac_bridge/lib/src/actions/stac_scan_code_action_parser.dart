import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacScanCodeActionParser implements StacActionParser<DeviceActionModel> {
  const StacScanCodeActionParser();
  @override
  String get actionType => 'scanCode';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final code = await MiniAppSessionStack.current?.host.scanCode();
    final saveAs = stringOf(model, 'saveAs', 'code');
    if (!context.mounted) return null;
    return completeDeviceCapture(
      context,
      model,
      (code == null || code.isEmpty) ? null : {saveAs: code},
    );
  }
}
