import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/flow_action_model.dart';

class StacOpenSheetActionParser implements StacActionParser<FlowActionModel> {
  const StacOpenSheetActionParser();
  @override
  String get actionType => 'openSheet';
  @override
  FlowActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(BuildContext context, FlowActionModel model) {
    final child = model['child'];
    if (child is! Map<Object?, Object?>) return null;
    return showAppSheet<void>(
      context,
      title: model['title'] as String?,
      subtitle: model['subtitle'] as String?,
      child: Builder(
        builder: (sheetContext) =>
            Stac.fromJson(Map<String, Object?>.from(child), sheetContext) ??
            const SizedBox.shrink(),
      ),
    );
  }
}
