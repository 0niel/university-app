import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppListRowParser extends StacParser<KitModel> {
  const StacAppListRowParser();

  @override
  String get type => 'appListRow';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final emoji = stringOrNullOf(model, 'emoji');
    final icon = iconOf(model, 'icon');
    final tone =
        colorOf(context, model, 'emojiColor') ??
        colorOf(context, model, 'iconColor') ??
        context.colors.accent;
    final leading =
        childWidget(context, model['leading']) ??
        (emoji != null
            ? AppIconAvatar(emoji: emoji, color: tone)
            : icon != null
            ? AppIconTile(
                icon: icon,
                background: context.colors.tintOf(tone),
                foreground: tone,
              )
            : null);
    return AppListRow(
      title: stringOf(model, 'title'),
      subtitle: stringOrNullOf(model, 'subtitle'),
      meta: stringOrNullOf(model, 'meta'),
      isFirst: boolOf(model, 'isFirst'),
      dense: boolOf(model, 'dense'),
      strong: boolOf(model, 'strong'),
      destructive: boolOf(model, 'destructive'),
      showChevron: model.containsKey('showChevron')
          ? boolOf(model, 'showChevron')
          : null,
      leading: leading,
      trailing: childWidget(context, model['trailing']),
      onTap: actionOf(context, model, const ['onTap', 'onPressed']),
      onDelete: actionOf(context, model, const ['onDelete']),
    );
  }
}
