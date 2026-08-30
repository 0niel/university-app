import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/actions/state_capture.dart';

typedef DeviceActionModel = Map<String, Object?>;
FutureOr<Object?> completeDeviceCapture(
  BuildContext context,
  DeviceActionModel model,
  Map<String, Object?>? values,
) => writeStateAndFollowUp(
  context,
  values: values,
  onSuccess: model['onResult'],
  onFailure: model['onCancel'],
);
