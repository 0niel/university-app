import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_section_title.freezed.dart';
part 'stac_app_section_title.g.dart';

@freezed
abstract class StacAppSectionTitle with _$StacAppSectionTitle {
  const factory StacAppSectionTitle({
    required String title,
    String? subtitle,
    String? action,
    @JsonKey(name: 'onActionTap') Object? actionJson,
  }) = _StacAppSectionTitle;

  factory StacAppSectionTitle.fromJson(Map<String, dynamic> json) =>
      _$StacAppSectionTitleFromJson(json);
}

class StacAppSectionTitleParser extends StacParser<StacAppSectionTitle> {
  const StacAppSectionTitleParser();

  @override
  String get type => 'appSectionTitle';

  @override
  StacAppSectionTitle getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppSectionTitle model) {
    return AppSectionTitle(
      title: model.title,
      subtitle: model.subtitle,
      action: model.action,
      onActionTap: actionCallback(context, model.actionJson),
    );
  }
}
