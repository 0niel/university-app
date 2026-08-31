import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacPickImageActionParser implements StacActionParser<DeviceActionModel> {
  const StacPickImageActionParser();
  @override
  String get actionType => 'pickImage';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final url = await MiniAppSessionStack.current?.host.pickImage(
      fromCamera: stringOf(model, 'source', 'camera') != 'gallery',
    );
    final saveAs = stringOf(model, 'saveAs', 'photo');
    if (!context.mounted) return null;
    return completeDeviceCapture(
      context,
      model,
      (url == null || url.isEmpty) ? null : {saveAs: url},
    );
  }
}
