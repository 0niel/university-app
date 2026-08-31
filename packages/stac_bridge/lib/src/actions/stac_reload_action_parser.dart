import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/flow_action_model.dart';
import 'package:stac_bridge/src/mini_app_host.dart';

class StacReloadActionParser implements StacActionParser<FlowActionModel> {
  const StacReloadActionParser();
  @override
  String get actionType => 'reload';
  @override
  FlowActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(BuildContext context, FlowActionModel model) =>
      MiniAppSessionStack.current?.host.reload();
}
