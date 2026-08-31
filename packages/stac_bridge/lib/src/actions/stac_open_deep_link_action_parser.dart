import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacOpenDeepLinkActionParser implements StacActionParser<String> {
  const StacOpenDeepLinkActionParser();

  @override
  String get actionType => 'openDeepLink';

  @override
  String getModel(Map<String, dynamic> json) => stringOf(json, 'location');

  @override
  FutureOr<Object?> onCall(BuildContext context, String model) {
    return MiniAppSessionStack.current?.host.openLocation(model);
  }
}
