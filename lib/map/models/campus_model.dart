import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/map/models/floor_model.dart';

part 'campus_model.freezed.dart';

@freezed
abstract class CampusModel with _$CampusModel {
  const factory CampusModel({
    required String id,
    required String displayName,
    required List<FloorModel> floors,
  }) = _CampusModel;
}
