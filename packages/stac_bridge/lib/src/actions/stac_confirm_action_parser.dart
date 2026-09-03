import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/flow_action_model.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacConfirmActionParser implements StacActionParser<FlowActionModel> {
  const StacConfirmActionParser();

  @override
  String get actionType => 'confirm';

  @override
  FlowActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(BuildContext context, FlowActionModel model) async {
    final message = stringOf(model, 'message');
    final confirmed = await showAppConfirmDialog(
      context,
      title: stringOf(model, 'title'),
      message: message.isEmpty ? null : message,
      confirmLabel: stringOf(model, 'confirmLabel', 'OK'),
      cancelLabel: stringOf(
        model,
        'cancelLabel',
        kitText(context, ru: 'Отмена', en: 'Cancel'),
      ),
      destructive: boolOf(model, 'isDanger') || boolOf(model, 'destructive'),
    );
    if (!context.mounted) return null;
    final followUp = confirmed ? model['onConfirm'] : model['onCancel'];
    return followUp is Map<Object?, Object?>
        ? Stac.onCallFromJson(Map<String, Object?>.from(followUp), context)
        : null;
  }
}
