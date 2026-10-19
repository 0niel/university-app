import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

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
      lineIcon: iconOf(model, 'icon') ?? .alert,
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
