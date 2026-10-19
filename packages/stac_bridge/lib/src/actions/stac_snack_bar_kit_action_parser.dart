import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacSnackBarKitActionParser implements StacActionParser<KitModel> {
  const StacSnackBarKitActionParser();

  @override
  String get actionType => 'showSnackBar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  FutureOr<Object?> onCall(BuildContext context, KitModel model) {
    final message = labelOf(model['content']);
    if (message.isEmpty) return null;
    final action = model['action'];
    final actionModel = action is Map<Object?, Object?>
        ? KitModel.from(action)
        : null;
    ToastManager.showInfo(
      context,
      message: message,
      actionLabel: actionModel == null
          ? null
          : stringOrNullOf(actionModel, 'label'),
      onAction: actionModel == null
          ? null
          : actionCallback(context, actionModel['onPressed']),
    );
    return null;
  }
}
