import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_meta_pill.freezed.dart';
part 'stac_app_meta_pill.g.dart';

@freezed
abstract class StacAppMetaPill with _$StacAppMetaPill {
  const factory StacAppMetaPill({
    required String text,
    @Default(false) bool strong,
  }) = _StacAppMetaPill;

  factory StacAppMetaPill.fromJson(Map<String, dynamic> json) =>
      _$StacAppMetaPillFromJson(json);
}

class StacAppMetaPillParser extends StacParser<StacAppMetaPill> {
  const StacAppMetaPillParser();

  @override
  String get type => 'appMetaPill';

  @override
  StacAppMetaPill getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppMetaPill model) {
    return AppMetaPill(text: model.text, strong: model.strong);
  }
}
