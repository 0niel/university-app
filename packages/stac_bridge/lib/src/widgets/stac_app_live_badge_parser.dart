import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppLiveBadgeParser extends StacParser<String> {
  const StacAppLiveBadgeParser();

  @override
  String get type => 'appLiveBadge';

  @override
  String getModel(Map<String, dynamic> json) =>
      stringOf(json, 'label', 'Сейчас');

  @override
  Widget parse(BuildContext context, String model) =>
      AppLiveBadge(label: model);
}
