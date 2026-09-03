import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacCardKitParser extends StacParser<KitModel> {
  const StacCardKitParser();

  @override
  String get type => 'card';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppCard(
    color: colorOf(context, model, 'color'),
    margin: model.containsKey('margin') ? insetsOf(model, 'margin', 0) : null,
    padding: EdgeInsets.zero,
    child: childWidget(context, model['child']) ?? const SizedBox.shrink(),
  );
}

class StacListTileKitParser extends StacParser<KitModel> {
  const StacListTileKitParser();

  @override
  String get type => 'listTile';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final subtitle = labelOf(model['subtitle']);
    return AppListRow(
      title: labelOf(model['title']),
      subtitle: subtitle.isEmpty ? null : subtitle,
      dense: boolOf(model, 'dense'),
      isFirst: true,
      leading: childWidget(context, model['leading']),
      trailing: childWidget(context, model['trailing']),
      onTap: boolOf(model, 'enabled', fallback: true)
          ? actionCallback(context, model['onTap'])
          : null,
    );
  }
}

class StacDividerKitParser extends StacParser<KitModel> {
  const StacDividerKitParser();

  @override
  String get type => 'divider';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppDivider(
    indent: doubleOr(model, 'indent', 0),
    endIndent: doubleOr(model, 'endIndent', 0),
    color: colorOf(context, model, 'color'),
  );
}

class StacVerticalDividerKitParser extends StacParser<KitModel> {
  const StacVerticalDividerKitParser();

  @override
  String get type => 'verticalDivider';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      AppVerticalDivider(color: colorOf(context, model, 'color'));
}

class StacChipKitParser extends StacParser<KitModel> {
  const StacChipKitParser();

  @override
  String get type => 'chip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppChip(
    label: labelOf(model['label']),
    leading: childWidget(context, model['avatar']),
    color:
        colorOf(context, model, 'backgroundColor') ??
        colorOf(context, model, 'color'),
    onRemove: actionCallback(context, model['onDeleted']),
    removeSemanticLabel: stringOrNullOf(model, 'deleteButtonTooltipMessage'),
  );
}

class StacCircleAvatarKitParser extends StacParser<KitModel> {
  const StacCircleAvatarKitParser();

  @override
  String get type => 'circleAvatar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppAvatar(
    name: labelOf(model['child']),
    size: doubleOr(model, 'radius', 20) * 2,
    color: colorOf(context, model, 'backgroundColor'),
    imageUrl:
        stringOrNullOf(model, 'backgroundImage') ??
        stringOrNullOf(model, 'foregroundImage'),
  );
}

class StacBadgeKitParser extends StacParser<KitModel> {
  const StacBadgeKitParser();

  @override
  String get type => 'badge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final count = intOf(model, 'count');
    final label = labelOf(model['label']);
    final visible = boolOf(model, 'isLabelVisible', fallback: true);
    final Widget badge = count != null
        ? AppCountBadge(count, max: intOf(model, 'maxCount') ?? 999)
        : label.isNotEmpty
        ? AppBadge(label: label, tone: AppBadgeTone.exam)
        : AppDot(size: 8, color: colorOf(context, model, 'backgroundColor'));
    final child = childWidget(context, model['child']);
    if (child == null) return visible ? badge : const SizedBox.shrink();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (visible) Positioned(top: -4, right: -4, child: badge),
      ],
    );
  }
}

class StacTooltipKitParser extends StacParser<KitModel> {
  const StacTooltipKitParser();

  @override
  String get type => 'tooltip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final child = childWidget(context, model['child']);
    if (child == null) return const SizedBox.shrink();
    return AppTooltipAnchor(message: stringOf(model, 'message'), child: child);
  }
}
