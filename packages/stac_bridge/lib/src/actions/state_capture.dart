import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

FutureOr<Object?> writeStateAndFollowUp(
  BuildContext context, {
  required Map<String, Object?>? values,
  required Object? onSuccess,
  required Object? onFailure,
}) {
  if (values != null) {
    final store = MiniAppStateScope.of(context);
    store?.setAll(values);
  }
  final followUp = values != null ? onSuccess : onFailure;
  if (followUp is Map<Object?, Object?>) {
    return Stac.onCallFromJson(Map<String, Object?>.from(followUp), context);
  }
  return null;
}
