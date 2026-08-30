import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacPickDateTimeActionParser
    implements StacActionParser<DeviceActionModel> {
  const StacPickDateTimeActionParser();
  @override
  String get actionType => 'pickDateTime';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final mode = stringOf(model, 'mode', 'datetime');
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day);
    if (mode != 'time') {
      final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1),
        lastDate: DateTime(now.year + 5),
      );
      if (!context.mounted) return null;
      if (picked == null) return completeDeviceCapture(context, model, null);
      date = picked;
    }
    var time = const TimeOfDay(hour: 0, minute: 0);
    if (mode != 'date') {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (!context.mounted) return null;
      if (picked == null) return completeDeviceCapture(context, model, null);
      time = picked;
    }
    final result = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return completeDeviceCapture(context, model, {
      stringOf(model, 'saveAs', 'datetime'): result.toIso8601String(),
    });
  }
}
