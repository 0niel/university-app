import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/app_state_scope_view.dart';

part 'stac_app_state_scope.freezed.dart';

@Freezed(fromJson: false, toJson: false)
abstract class StacAppStateScope with _$StacAppStateScope {
  const factory StacAppStateScope({
    required Map<String, Object?> initial,
    Map<String, Object?>? child,
  }) = _StacAppStateScope;

  factory StacAppStateScope.fromJson(Map<String, dynamic> json) {
    return StacAppStateScope(
      initial: json['initial'] is Map<Object?, Object?>
          ? Map.from(json['initial'] as Map<Object?, Object?>)
          : const {},
      child: json['child'] is Map<Object?, Object?>
          ? Map.from(json['child'] as Map<Object?, Object?>)
          : null,
    );
  }
}

class StacAppStateScopeParser extends StacParser<StacAppStateScope> {
  const StacAppStateScopeParser();

  @override
  String get type => 'appStateScope';

  @override
  StacAppStateScope getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppStateScope model) =>
      AppStateScopeView(model: model);
}
