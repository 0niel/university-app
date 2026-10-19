import 'dart:async';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacDialogKitActionParser implements StacActionParser<KitModel> {
  const StacDialogKitActionParser();

  @override
  String get actionType => 'showDialog';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  FutureOr<Object?> onCall(BuildContext context, KitModel model) {
    final widget = model['widget'];
    if (widget is! Map<Object?, Object?>) return null;
    final json = Map<String, Object?>.from(widget);
    final dismissible = boolOf(model, 'barrierDismissible', fallback: true);
    Widget build(BuildContext dialogContext) =>
        Stac.fromJson(json, dialogContext) ?? const SizedBox.shrink();
    if (json['type'] == 'alertDialog') {
      return showNinjaDialog<void>(
        context,
        barrierDismissible: dismissible,
        builder: build,
      );
    }
    return showAppDialog<void>(
      context,
      barrierDismissible: dismissible,
      builder: (dialogContext) => Padding(
        padding: const .all(AppSpacing.xl),
        child: build(dialogContext),
      ),
    );
  }
}
