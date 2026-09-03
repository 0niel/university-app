import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

AppBadgeTone appBadgeToneOf(String? name) => switch (name) {
  'accent' => AppBadgeTone.accent,
  'ink' || 'solid' => AppBadgeTone.ink,
  'exam' || 'danger' => AppBadgeTone.exam,
  'warn' => AppBadgeTone.warn,
  'lecture' || 'success' || 'live' => AppBadgeTone.lecture,
  'lab' => AppBadgeTone.lab,
  'practice' || 'info' => AppBadgeTone.practice,
  _ => AppBadgeTone.neutral,
};

class StacAppTagParser extends StacParser<KitModel> {
  const StacAppTagParser();

  @override
  String get type => 'appTag';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon');
    return AppTag(
      label: stringOf(model, 'label'),
      tone: enumByName(
        AppTagTone.values,
        stringOrNullOf(model, 'tone'),
        AppTagTone.mute,
      ),
      leading: boolOf(model, 'withDot')
          ? AppLiveDot(color: colorOf(context, model, 'dotColor'))
          : icon == null
          ? null
          : AppLineIconWidget(icon, size: 12),
    );
  }
}

class StacAppLiveBadgeParser extends StacParser<KitModel> {
  const StacAppLiveBadgeParser();

  @override
  String get type => 'appLiveBadge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      AppLiveBadge(label: stringOf(model, 'label', 'Сейчас'));
}

class StacAppBadgeParser extends StacParser<KitModel> {
  const StacAppBadgeParser();

  @override
  String get type => 'appBadge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppBadge(
    label: stringOf(model, 'label'),
    tone: appBadgeToneOf(stringOrNullOf(model, 'tone')),
    dot: boolOf(model, 'dot'),
    icon: iconOf(model, 'icon'),
  );
}

class StacAppCountBadgeParser extends StacParser<KitModel> {
  const StacAppCountBadgeParser();

  @override
  String get type => 'appCountBadge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      AppCountBadge(intOf(model, 'count') ?? 0, max: intOf(model, 'max') ?? 99);
}

class StacAppTypeTagParser extends StacParser<KitModel> {
  const StacAppTypeTagParser();

  @override
  String get type => 'appTypeTag';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppTypeTag(
    stringOf(model, 'label'),
    color: colorOf(context, model, 'color'),
  );
}

class StacAppHashTagParser extends StacParser<KitModel> {
  const StacAppHashTagParser();

  @override
  String get type => 'appHashTag';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppHashTag(
    label: stringOf(model, 'label'),
    color: colorOf(context, model, 'color'),
    onTap: actionOf(context, model, const ['onTap', 'onPressed']),
  );
}

class StacAppMetaPillParser extends StacParser<KitModel> {
  const StacAppMetaPillParser();

  @override
  String get type => 'appMetaPill';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon');
    return AppMetaPill(
      text: stringOf(model, 'text'),
      strong: boolOf(model, 'strong'),
      icon: icon == null ? null : AppLineIconWidget(icon, size: 14),
      iconColor: colorOf(context, model, 'iconColor'),
    );
  }
}
