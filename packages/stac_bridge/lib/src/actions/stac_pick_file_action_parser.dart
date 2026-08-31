import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacPickFileActionParser implements StacActionParser<DeviceActionModel> {
  const StacPickFileActionParser();
  @override
  String get actionType => 'pickFile';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final file = await MiniAppSessionStack.current?.host.pickFile();
    final saveAs = stringOf(model, 'saveAs', 'file');
    final url = file?['url'];
    if (!context.mounted) return null;
    return completeDeviceCapture(
      context,
      model,
      (url == null || url.isEmpty)
          ? null
          : {saveAs: url, '${saveAs}Name': file?['name'] ?? ''},
    );
  }
}
