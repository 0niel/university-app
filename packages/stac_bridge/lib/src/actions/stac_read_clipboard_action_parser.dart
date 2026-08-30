import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacReadClipboardActionParser
    implements StacActionParser<DeviceActionModel> {
  const StacReadClipboardActionParser();
  @override
  String get actionType => 'readClipboard';
  @override
  DeviceActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    DeviceActionModel model,
  ) async {
    final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    final saveAs = stringOf(model, 'saveAs', 'clipboard');
    if (!context.mounted) return null;
    return completeDeviceCapture(
      context,
      model,
      text.isEmpty ? null : {saveAs: text},
    );
  }
}
