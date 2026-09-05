import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';
import 'package:stac_bridge/src/actions/device_action_support.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
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
    final store = MiniAppStateScope.of(context);
    final stableContext = store?.actionContext ?? context;
    final loadingKey = stringOf(model, 'loadingKey');
    final errorKey = stringOf(model, 'errorKey');
    store?.setAll({
      if (loadingKey.isNotEmpty) loadingKey: true,
      if (errorKey.isNotEmpty) errorKey: null,
    });
    try {
      final url = await MiniAppSessionStack.current?.host.pickImage(
        fromCamera: stringOf(model, 'source', 'camera') != 'gallery',
      );
      final saveAs = stringOf(model, 'saveAs', 'photo');
      if (!stableContext.mounted || store?.isDisposed == true) return null;
      return await completeDeviceCapture(
        stableContext,
        model,
        (url == null || url.isEmpty) ? null : {saveAs: url},
      );
    } on Exception {
      if (!stableContext.mounted || store?.isDisposed == true) return null;
      if (errorKey.isNotEmpty) store?.set(errorKey, 'upload_failed');
      final onError = model['onError'];
      if (onError != null) {
        return await runMiniAppAction(stableContext, onError);
      }
      rethrow;
    } finally {
      if (loadingKey.isNotEmpty) store?.set(loadingKey, false);
    }
  }
}
