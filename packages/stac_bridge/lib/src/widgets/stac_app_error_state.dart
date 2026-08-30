import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_error_state.freezed.dart';
part 'stac_app_error_state.g.dart';

String _retryWhenNotString(Object? value) {
  return value is String ? value : 'Повторить';
}

@freezed
abstract class StacAppErrorState with _$StacAppErrorState {
  const factory StacAppErrorState({
    @JsonKey(fromJson: stringOrEmpty) required String title,
    @JsonKey(fromJson: stringOrEmpty) required String message,
    @JsonKey(fromJson: _retryWhenNotString)
    @Default('Повторить')
    String primaryLabel,
    @JsonKey(name: 'onPrimary') Object? primaryActionJson,
  }) = _StacAppErrorState;

  factory StacAppErrorState.fromJson(Map<String, dynamic> json) =>
      _$StacAppErrorStateFromJson(json);
}

class StacAppErrorStateParser extends StacParser<StacAppErrorState> {
  const StacAppErrorStateParser();

  @override
  String get type => 'appErrorState';

  @override
  StacAppErrorState getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppErrorState model) {
    return AppErrorState(
      icon: Icons.error_outline_rounded,
      title: model.title,
      message: model.message,
      primaryLabel: model.primaryLabel,
      onPrimary: actionCallback(context, model.primaryActionJson),
      footnote: null,
    );
  }
}
