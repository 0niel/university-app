import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

/// Writes [values] into the nearest [MiniAppStateScope] (so they render as
/// `{{state.*}}`), then runs the follow-up action: [onSuccess] when something
/// was captured, [onFailure] otherwise.
///
/// Follow-ups are resolved from the original action JSON, so they cannot carry
/// the fresh value — read it from `{{state.*}}` in a later widget/action.
/// Shared by every capture-style action (device capabilities and `fetch`).
FutureOr<Object?> writeStateAndFollowUp(
  BuildContext context, {
  required Map<String, Object?>? values,
  required Object? onSuccess,
  required Object? onFailure,
}) {
  if (values != null) {
    final store = MiniAppStateScope.of(context);
    if (store != null) values.forEach(store.set);
  }
  final followUp = values != null ? onSuccess : onFailure;
  if (followUp is Map<Object?, Object?>) {
    return Stac.onCallFromJson(Map<String, Object?>.from(followUp), context);
  }
  return null;
}
