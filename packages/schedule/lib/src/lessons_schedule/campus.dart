import 'package:freezed_annotation/freezed_annotation.dart';

part 'campus.freezed.dart';
part 'campus.g.dart';

@freezed
abstract class Campus with _$Campus {
  @Assert(
    'latitude == null && longitude == null || '
        'latitude != null && longitude != null',
    'Latitude and longitude must be both null or both not null',
  )
  const factory Campus({
    required String name,
    String? shortName,
    double? latitude,
    double? longitude,
    String? uid,
  }) = _Campus;

  factory Campus.fromJson(Map<String, dynamic> json) => _$CampusFromJson(json);
}
