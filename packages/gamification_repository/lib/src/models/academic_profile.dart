import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/src/models/json_converters.dart';

part 'academic_profile.freezed.dart';
part 'academic_profile.g.dart';

@freezed
abstract class AcademicProfile with _$AcademicProfile {
  const factory AcademicProfile({
    String? handle,
    String? group,
    int? course,
    String? fullName,
    String? studentCardNumber,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? cardValidUntil,
  }) = _AcademicProfile;

  factory AcademicProfile.fromJson(Map<String, Object?> json) =>
      _$AcademicProfileFromJson(json);

  static const empty = AcademicProfile();
}
