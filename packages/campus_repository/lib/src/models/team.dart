import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
abstract class Team with _$Team {
  const factory Team({
    required String id,
    required String title,
    @Default('') String eventName,
    @Default('') String description,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> neededRoles,
    @Default(5) int capacity,
    @Default('hackathon') String kind,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? deadlineAt,
    @Default(false) bool isBoosted,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @Default(false) bool isMine,
    @Default(false) bool isMember,
    @Default(false) bool hasApplied,
    String? myApplicationId,
    @Default(TeamStatus.open) TeamStatus status,
    @Default(0) int applicationsCount,
    @Default(1) int memberCount,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> memberNames,
  }) = _Team;

  const Team._();

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);

  bool get isFull => memberCount >= capacity;
}

enum TeamStatus { open, closed, completed, archived }

enum TeamApplicationStatus { pending, accepted, rejected, withdrawn }

enum TeamApplicationAction {
  accept('accept'),
  reject('reject'),
  withdraw('withdraw');

  const TeamApplicationAction(this.wireValue);

  final String wireValue;
}

@freezed
abstract class TeamApplication with _$TeamApplication {
  const factory TeamApplication({
    required String id,
    required String teamId,
    required String applicantId,
    @Default('') String role,
    @Default('') String message,
    @Default('') String applicantName,
    String? applicantHandle,
    String? applicantGroup,
    @Default(false) bool attachProfile,
    @Default(TeamApplicationStatus.pending) TeamApplicationStatus status,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
  }) = _TeamApplication;

  factory TeamApplication.fromJson(Map<String, Object?> json) =>
      _$TeamApplicationFromJson(json);
}
