import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/flow_action_model.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacOpenMiniAppActionParser implements StacActionParser<FlowActionModel> {
  const StacOpenMiniAppActionParser();
  @override
  String get actionType => 'openMiniApp';
  @override
  FlowActionModel getModel(Map<String, dynamic> json) => .from(json);
  @override
  FutureOr<Object?> onCall(BuildContext context, FlowActionModel model) {
    final slug = stringOf(model, 'slug').trim().toLowerCase();
    if (slug.isEmpty) return null;
    final page = model['page'] as String?;
    return MiniAppSessionStack.current?.host.openMiniApp(
      slug: slug,
      path: page != null && page.startsWith('/') ? page : null,
    );
  }
}
