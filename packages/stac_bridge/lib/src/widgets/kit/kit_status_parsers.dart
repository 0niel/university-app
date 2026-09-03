import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppEmptyStateParser extends StacParser<KitModel> {
  const StacAppEmptyStateParser();

  @override
  String get type => 'appEmptyState';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final title = stringOf(model, 'title');
    final subtitle = stringOrNullOf(model, 'subtitle');
    if (boolOf(model, 'compact')) {
      return AppEmptyState.compact(title: title, subtitle: subtitle);
    }
    final icon = iconOf(model, 'icon');
    return AppEmptyState(
      emoji: icon == null ? stringOf(model, 'emoji', '✨') : null,
      lineIcon: icon ?? AppLineIcon.inbox,
      title: title,
      subtitle: subtitle,
      actionLabel: stringOrNullOf(model, 'actionLabel'),
      onAction: actionOf(context, model, const ['onAction', 'onPressed']),
      child: childWidget(context, model['child']),
    );
  }
}

class StacAppErrorStateParser extends StacParser<KitModel> {
  const StacAppErrorStateParser();

  @override
  String get type => 'appErrorState';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final title = stringOf(model, 'title');
    final message = stringOrNullOf(model, 'message');
    if (boolOf(model, 'compact')) {
      return AppErrorState.compact(title: title, message: message);
    }
    return AppErrorState(
      lineIcon: iconOf(model, 'icon') ?? AppLineIcon.alert,
      title: title,
      message: message,
      primaryLabel: stringOf(
        model,
        'primaryLabel',
        kitText(context, ru: 'Повторить', en: 'Retry'),
      ),
      onPrimary: actionOf(context, model, const ['onPrimary', 'onRetry']),
      secondaryLabel: stringOrNullOf(model, 'secondaryLabel'),
      onSecondary: actionOf(context, model, const ['onSecondary']),
      footnote: stringOrNullOf(model, 'footnote'),
    );
  }
}
