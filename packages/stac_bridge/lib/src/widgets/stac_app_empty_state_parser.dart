import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_bridge/src/widgets/stac_app_empty_state.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppEmptyStateParser extends StacParser<StacAppEmptyState> {
  const StacAppEmptyStateParser();

  @override
  String get type => 'appEmptyState';

  @override
  StacAppEmptyState getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppEmptyState model) {
    return AppEmptyState(
      emoji: model.emoji,
      title: model.title,
      subtitle: model.subtitle,
      child: childWidget(context, model.child),
    );
  }
}
