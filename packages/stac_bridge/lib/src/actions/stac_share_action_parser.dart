import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacShareActionParser implements StacActionParser<String> {
  const StacShareActionParser();

  @override
  String get actionType => 'share';

  @override
  String getModel(Map<String, dynamic> json) => stringOf(json, 'text');

  @override
  FutureOr<Object?> onCall(BuildContext context, String model) {
    if (model.isEmpty) return null;
    return SharePlus.instance.share(ShareParams(text: model));
  }
}
