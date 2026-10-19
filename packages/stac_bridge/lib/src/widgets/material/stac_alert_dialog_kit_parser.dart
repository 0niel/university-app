import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAlertDialogKitParser extends StacParser<KitModel> {
  const StacAlertDialogKitParser();

  @override
  String get type => 'alertDialog';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final actions = mapListOf(model, 'actions');
    final content = model['content'];
    final message = labelOf(content);
    final confirm = actions.lastOrNull;
    final cancel = actions.length > 1 ? actions.firstOrNull : null;
    return NinjaDialog(
      title: labelOf(model['title']),
      message: message.isEmpty ? null : message,
      icon: childWidget(context, model['icon']),
      confirmLabel: confirm == null ? null : labelOf(confirm['child']),
      onConfirm: confirm == null
          ? null
          : (actionCallback(context, confirm['onPressed']) ??
                () => Navigator.of(context).maybePop()),
      cancelLabel: cancel == null ? null : labelOf(cancel['child']),
      onCancel: cancel == null
          ? null
          : (actionCallback(context, cancel['onPressed']) ??
                () => Navigator.of(context).maybePop()),
      child: message.isEmpty ? childWidget(context, content) : null,
    );
  }
}
