import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppCardParser extends StacParser<KitModel> {
  const StacAppCardParser();

  @override
  String get type => 'appCard';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppCard(
    color: colorOf(context, model, 'color'),
    tinted: boolOf(model, 'tinted'),
    radius: doubleOr(model, 'radius', AppRadius.card),
    padding: insetsOf(model, 'padding', 16),
    margin: model.containsKey('margin') ? insetsOf(model, 'margin', 0) : null,
    width: doubleOf(model, 'width'),
    height: doubleOf(model, 'height'),
    semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
    onTap: actionOf(context, model, const ['onTap', 'onPressed']),
    onLongPress: actionOf(context, model, const ['onLongPress']),
    child: childWidget(context, model['child']) ?? const SizedBox.shrink(),
  );
}

class StacAppListGroupParser extends StacParser<KitModel> {
  const StacAppListGroupParser();

  @override
  String get type => 'appListGroup';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppListGroup(
    radius: doubleOr(model, 'radius', AppRadius.card),
    color: colorOf(context, model, 'color'),
    margin: model.containsKey('margin') ? insetsOf(model, 'margin', 0) : null,
    dividerIndent: doubleOr(model, 'dividerIndent', 0),
    showDividers: boolOf(model, 'showDividers', fallback: true),
    children: childrenWidgets(context, model['children']),
  );
}

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

class StacAppDividerParser extends StacParser<KitModel> {
  const StacAppDividerParser();

  @override
  String get type => 'appDivider';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final color = colorOf(context, model, 'color');
    if (boolOf(model, 'vertical')) {
      return AppVerticalDivider(
        height: doubleOf(model, 'height'),
        color: color,
      );
    }
    if (boolOf(model, 'inset')) return AppDivider.inset(color: color);
    return AppDivider(
      indent: doubleOr(model, 'indent', 0),
      endIndent: doubleOr(model, 'endIndent', 0),
      color: color,
    );
  }
}
