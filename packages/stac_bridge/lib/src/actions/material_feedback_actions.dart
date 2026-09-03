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

class StacDialogKitActionParser implements StacActionParser<KitModel> {
  const StacDialogKitActionParser();

  @override
  String get actionType => 'showDialog';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  FutureOr<Object?> onCall(BuildContext context, KitModel model) {
    final widget = model['widget'];
    if (widget is! Map<Object?, Object?>) return null;
    final json = Map<String, Object?>.from(widget);
    final dismissible = boolOf(model, 'barrierDismissible', fallback: true);
    Widget build(BuildContext dialogContext) =>
        Stac.fromJson(json, dialogContext) ?? const SizedBox.shrink();
    if (json['type'] == 'alertDialog') {
      return showNinjaDialog<void>(
        context,
        barrierDismissible: dismissible,
        builder: build,
      );
    }
    return showAppDialog<void>(
      context,
      barrierDismissible: dismissible,
      builder: (dialogContext) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: build(dialogContext),
      ),
    );
  }
}

class StacModalBottomSheetKitActionParser
    implements StacActionParser<KitModel> {
  const StacModalBottomSheetKitActionParser();

  @override
  String get actionType => 'showModalBottomSheet';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  FutureOr<Object?> onCall(BuildContext context, KitModel model) {
    final widget = model['widget'];
    if (widget is! Map<Object?, Object?>) return null;
    final json = Map<String, Object?>.from(widget);
    return showAppSheet<void>(
      context,
      isDismissible: boolOf(model, 'isDismissible', fallback: true),
      showGrabber: boolOf(model, 'showDragHandle', fallback: true),
      child: Builder(
        builder: (sheetContext) =>
            Stac.fromJson(json, sheetContext) ?? const SizedBox.shrink(),
      ),
    );
  }
}
