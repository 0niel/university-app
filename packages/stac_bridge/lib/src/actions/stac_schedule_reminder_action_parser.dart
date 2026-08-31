import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacScheduleReminderActionParser
    implements StacActionParser<DeviceActionModel> {
  const StacScheduleReminderActionParser();
  @override
  String get actionType => 'scheduleReminder';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final when = stringOf(model, 'when');
    if (when.isEmpty) return completeDeviceCapture(context, model, null);
    final id = await MiniAppSessionStack.current?.host.scheduleReminder(
      title: stringOf(model, 'title', 'Напоминание'),
      body: stringOf(model, 'body'),
      whenIso: when,
    );
    final saveAs = stringOf(model, 'saveAs', 'reminderId');
    if (!context.mounted) return null;
    return completeDeviceCapture(
      context,
      model,
      id == null ? null : {saveAs: id},
    );
  }
}
