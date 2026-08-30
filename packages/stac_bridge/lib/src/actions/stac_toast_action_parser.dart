import 'dart:async';

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
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(model)));
    return null;
  }
}
