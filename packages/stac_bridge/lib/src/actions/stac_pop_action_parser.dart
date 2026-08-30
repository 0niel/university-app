import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/flow_action_model.dart';

class StacPopActionParser implements StacActionParser<FlowActionModel> {
  const StacPopActionParser();
  @override
  String get actionType => 'pop';
  @override
  FlowActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(BuildContext context, FlowActionModel model) =>
      Navigator.of(context).maybePop();
}
