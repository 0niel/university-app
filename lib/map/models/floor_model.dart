import 'package:freezed_annotation/freezed_annotation.dart';

part 'floor_model.freezed.dart';

@freezed
abstract class FloorModel with _$FloorModel {
  const factory FloorModel({
    required String id,
    required int number,
    required String svgPath,
  }) = _FloorModel;
}
