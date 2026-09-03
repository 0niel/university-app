import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stac_bridge/src/actions/host_action_models.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacCopyActionParser implements StacActionParser<HostActionModel> {
  const StacCopyActionParser();

  @override
  String get actionType => 'copyToClipboard';

  @override
  HostActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    HostActionModel model,
  ) async {
    final text = stringOf(model, 'text');
    if (text.isEmpty) return null;
    await Clipboard.setData(ClipboardData(text: text));
    final message = stringOf(model, 'message');
    if (message.isNotEmpty && context.mounted) {
      ToastManager.showSuccess(context, message: message);
    }
    return null;
  }
}
