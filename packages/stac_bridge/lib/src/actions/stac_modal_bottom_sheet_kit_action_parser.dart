import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacModalBottomSheetKitActionParser
    implements StacActionParser<KitModel> {
  const StacModalBottomSheetKitActionParser();

  @override
  String get actionType => 'showModalBottomSheet';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  FutureOr<Object?> onCall(BuildContext context, KitModel model) {
    final widget = model['widget'];
    if (widget is! Map<Object?, Object?>) return null;
    final json = Map<String, Object?>.from(widget);
    return showAppSheet<void>(
      context,
      isDismissible: boolOf(model, 'isDismissible', fallback: true),
      showGrabber: boolOf(model, 'showDragHandle', fallback: true),
      child: Builder(
        builder: (sheetContext) =>
            Stac.fromJson(json, sheetContext) ?? const SizedBox.shrink(),
      ),
    );
  }
}
