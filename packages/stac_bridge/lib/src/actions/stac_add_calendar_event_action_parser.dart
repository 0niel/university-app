import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAddCalendarEventActionParser
    implements StacActionParser<DeviceActionModel> {
  const StacAddCalendarEventActionParser();
  @override
  String get actionType => 'addCalendarEvent';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final start = stringOf(model, 'start');
    final title = stringOf(model, 'title');
    if (start.isEmpty || title.isEmpty) {
      return completeDeviceCapture(context, model, null);
    }
    final ok =
        await MiniAppSessionStack.current?.host.addCalendarEvent(
          title: title,
          startIso: start,
          endIso: model['end'] as String?,
          location: model['location'] as String?,
          notes: model['notes'] as String?,
        ) ??
        false;
    final saveAs = stringOf(model, 'saveAs', 'eventAdded');
    if (!context.mounted) return null;
    return completeDeviceCapture(context, model, ok ? {saveAs: true} : null);
  }
}
