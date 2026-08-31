import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacHapticActionParser implements StacActionParser<String> {
  const StacHapticActionParser();

  @override
  String get actionType => 'hapticFeedback';

  @override
  String getModel(Map<String, dynamic> json) =>
      stringOf(json, 'style', 'light');

  @override
  FutureOr<Object?> onCall(BuildContext context, String model) {
    return switch (model) {
      'medium' => HapticFeedback.mediumImpact(),
      'heavy' => HapticFeedback.heavyImpact(),
      'selection' => HapticFeedback.selectionClick(),
      'vibrate' => HapticFeedback.vibrate(),
      _ => HapticFeedback.lightImpact(),
    };
  }
}
