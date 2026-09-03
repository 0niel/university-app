import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacToastActionParser implements StacActionParser<KitModel> {
  const StacToastActionParser();

  @override
  String get actionType => 'showToast';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  FutureOr<Object?> onCall(BuildContext context, KitModel model) {
    final message = stringOf(model, 'message');
    if (message.isEmpty) return null;
    final actionLabel = stringOrNullOf(model, 'actionLabel');
    final onAction = actionCallback(context, model['onAction']);
    switch (stringOf(model, 'type')) {
      case 'success':
        ToastManager.showSuccess(
          context,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
        );
      case 'warning' || 'warn':
        ToastManager.showWarning(
          context,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
        );
      case 'error' || 'danger':
        ToastManager.showError(
          context,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
        );
      default:
        ToastManager.showInfo(
          context,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
        );
    }
    return null;
  }
}
