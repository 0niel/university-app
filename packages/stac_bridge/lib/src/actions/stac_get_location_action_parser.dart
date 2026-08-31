import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacGetLocationActionParser
    implements StacActionParser<DeviceActionModel> {
  const StacGetLocationActionParser();
  @override
  String get actionType => 'getLocation';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final location = await MiniAppSessionStack.current?.host.getLocation();
    final saveAs = stringOf(model, 'saveAs', 'loc');
    final values = location == null
        ? null
        : <String, Object?>{
            '${saveAs}Lat': location['lat'],
            '${saveAs}Lng': location['lng'],
            '${saveAs}Accuracy': location['accuracy'],
          };
    if (!context.mounted) return null;
    return completeDeviceCapture(context, model, values);
  }
}
