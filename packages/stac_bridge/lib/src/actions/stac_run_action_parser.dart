import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';

class StacRunActionParser implements StacActionParser<Map<String, Object?>> {
  const StacRunActionParser();

  @override
  String get actionType => 'appRunAction';

  @override
  Map<String, Object?> getModel(Map<String, dynamic> json) => json;

  @override
  Future<Object?> onCall(BuildContext context, Map<String, Object?> model) =>
      runMiniAppAction(context, model);
}
