import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'campus.g.dart';

/// {@template campus}
/// A campus is a location where classrooms are located.
/// {@endtemplate}
@JsonSerializable()
@immutable
class Campus extends Equatable {
  /// {@macro campus}
  const Campus({
    required this.name,
    this.shortName,
    this.latitude,
    this.longitude,
    this.uid,
  }) : assert(
          latitude == null && longitude == null || latitude != null && longitude != null,
          'Latitude and longitude must be both null or both not null',
        );

  /// Converts a `Map<String, dynamic>` into a [Campus] instance.
  factory Campus.fromJson(Map<String, dynamic> json) => _$CampusFromJson(json);

  /// Campus location name.
  final String name;

  /// The short name of the campus.
  final String? shortName;

  /// The latitude of the campus. This is used for displaying the campus on
  /// a map.
  final double? latitude;

  /// The longitude of the campus.
  final double? longitude;

  /// The unique identifier of the campus. This is used for identifying the
  /// campus in the database and in the API.
  final String? uid;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$CampusToJson(this);

  @override
  List<Object?> get props => [name, shortName, latitude, longitude, uid];
}
