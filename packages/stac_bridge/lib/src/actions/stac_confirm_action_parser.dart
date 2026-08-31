import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDialog(model: model),
    );
    if (!context.mounted) return null;
    final followUp = (confirmed ?? false)
        ? model['onConfirm']
        : model['onCancel'];
    return followUp is Map<Object?, Object?>
        ? Stac.onCallFromJson(Map<String, Object?>.from(followUp), context)
        : null;
  }
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({required this.model});
  final FlowActionModel model;
  @override
  Widget build(BuildContext context) {
    final message = stringOf(model, 'message');
    final dangerous = boolOf(model, 'isDanger');
    final confirm = stringOf(model, 'confirmLabel', 'OK');
    final cancel = stringOf(model, 'cancelLabel', 'Отмена');
    return AlertDialog(
      title: Text(stringOf(model, 'title')),
      content: message.isEmpty ? null : Text(message),
      actions: [
        AppButton.ghost(
          label: cancel,
          size: .small,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        if (dangerous)
          AppButton.danger(
            label: confirm,
            size: .small,
            onPressed: () => Navigator.of(context).pop(true),
          )
        else
          AppButton.primary(
            label: confirm,
            size: .small,
            onPressed: () => Navigator.of(context).pop(true),
          ),
      ],
    );
  }
}
