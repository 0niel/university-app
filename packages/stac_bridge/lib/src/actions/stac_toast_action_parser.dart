import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacToastActionParser implements StacActionParser<String> {
  const StacToastActionParser();

  @override
  String get actionType => 'showToast';

  @override
  String getModel(Map<String, dynamic> json) => stringOf(json, 'message');

  @override
  FutureOr<Object?> onCall(BuildContext context, String model) {
    if (model.isEmpty) return null;
    ToastManager.showInfo(context, message: model);
    return null;
  }
}
