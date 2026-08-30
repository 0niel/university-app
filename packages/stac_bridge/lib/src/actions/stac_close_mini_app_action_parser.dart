import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/actions/host_action_models.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_framework/stac_framework.dart';

class StacCloseMiniAppActionParser
    implements StacActionParser<HostActionModel> {
  const StacCloseMiniAppActionParser();

  @override
  String get actionType => 'closeMiniApp';

  @override
  HostActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(BuildContext context, HostActionModel model) {
    MiniAppSessionStack.current?.host.closeMiniApp();
    return null;
  }
}
