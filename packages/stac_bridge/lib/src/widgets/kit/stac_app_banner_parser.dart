import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_banner_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppBannerParser extends StacParser<KitModel> {
  const StacAppBannerParser();

  @override
  String get type => 'appBanner';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final title = stringOf(model, 'title');
    final tone = stringOrNullOf(model, 'tone');
    final actionLabel = stringOrNullOf(model, 'actionLabel');
    final onAction = actionOf(context, model, const ['onAction', 'onTap']);
    if (title.isNotEmpty) {
      final icon = iconOf(model, 'icon');
      return NinjaBanner(
        title: title,
        body: stringOrNullOf(model, 'message') ?? stringOrNullOf(model, 'body'),
        tone: ninjaBannerToneOf(tone),
        actionLabel: actionLabel,
        onAction: onAction,
        icon: icon == null ? null : AppLineIconWidget(icon, size: 18),
      );
    }
    return AppBanner(
      message: stringOf(model, 'message'),
      tone: appBannerToneOf(tone),
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
