import 'package:freezed_annotation/freezed_annotation.dart';

part 'stac_app_card.freezed.dart';
part 'stac_app_card.g.dart';

double _paddingFromJson(Object? value) => value is num ? value.toDouble() : 16;

@freezed
abstract class StacAppCard with _$StacAppCard {
  const factory StacAppCard({
    @JsonKey(fromJson: _paddingFromJson) @Default(16) double padding,
    String? color,
    @JsonKey(name: 'onTap') Object? actionJson,
    Object? child,
  }) = _StacAppCard;

  factory StacAppCard.fromJson(Map<String, dynamic> json) =>
      _$StacAppCardFromJson(json);
}
