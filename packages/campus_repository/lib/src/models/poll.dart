import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll.freezed.dart';
part 'poll.g.dart';

@Freezed(toJson: true)
abstract class Poll with _$Poll {
  const factory Poll({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String question,
    @JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson)
    required PollType pollType,
    @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)
    required List<PollOption> options,
    String? authorId,
    @Default(false) bool isAnonymous,
    @Default(true) bool showResults,
    @Default(false) bool isMine,
    @Default(0) int totalVotes,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? expiresAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
  }) = _Poll;

  const Poll._();

  factory Poll.fromJson(Map<String, Object?> json) => _$PollFromJson(json);

  bool get hasEnded {
    final deadline = expiresAt;
    return deadline != null && deadline.isBefore(DateTime.now());
  }

  bool get hasVoted => options.any((option) => option.votedByMe);
}

enum PollType {
  single('single'),
  multi('multi'),
  quiz('quiz');

  const PollType(this.wire);

  final String wire;

  static PollType fromWire(String? wire) => values.firstWhere(
    (value) => value.wire == wire,
    orElse: () => PollType.single,
  );
}

@freezed
abstract class PollOption with _$PollOption {
  const factory PollOption({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String text,
    @Default(0) int position,
    @Default(false) bool isCorrect,
    @Default(0) int votes,
    @Default(false) bool votedByMe,
  }) = _PollOption;

  const PollOption._();

  factory PollOption.fromJson(Map<String, Object?> json) =>
      _$PollOptionFromJson(json);

  double share(int total) => total <= 0 ? 0 : votes / total;
}

PollType _pollTypeFromJson(Object? value) =>
    PollType.fromWire(value is String ? value : null);

String _pollTypeToJson(PollType value) => value.wire;

List<PollOption> _optionsFromJson(Object? value) => value is List
    ? value
          .whereType<Map<Object?, Object?>>()
          .map((option) => PollOption.fromJson(option.cast()))
          .toList()
    : const [];

List<Map<String, Object?>> _optionsToJson(List<PollOption> value) =>
    value.map((option) => option.toJson()).toList();
