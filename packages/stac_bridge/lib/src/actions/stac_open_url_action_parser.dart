import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacOpenUrlActionParser implements StacActionParser<String> {
  const StacOpenUrlActionParser();

  @override
  String get actionType => 'openUrl';

  @override
  String getModel(Map<String, dynamic> json) => stringOf(json, 'url');

  @override
  FutureOr<Object?> onCall(BuildContext context, String model) {
    final url = Uri.tryParse(model);
    if (url == null || url.scheme != 'https') return null;
    return MiniAppSessionStack.current?.host.openExternalUrl(url);
  }
}
