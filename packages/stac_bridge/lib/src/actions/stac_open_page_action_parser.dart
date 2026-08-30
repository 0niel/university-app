import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/actions/host_action_models.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacOpenPageActionParser implements StacActionParser<HostActionModel> {
  const StacOpenPageActionParser();

  @override
  String get actionType => 'openPage';

  @override
  HostActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(BuildContext context, HostActionModel model) {
    final path = stringOf(model, 'path', '/');
    return MiniAppSessionStack.current?.host.openPage(
      path: path.startsWith('/') ? path : '/$path',
      title: model['title'] as String?,
    );
  }
}
