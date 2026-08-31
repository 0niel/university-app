import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/reaction_type.dart';

part 'reaction_counts.freezed.dart';

@Freezed(fromJson: false, toJson: false)
abstract class ReactionCounts with _$ReactionCounts {
  @Assert('fire >= 0', 'fire must be non-negative')
  @Assert('brain >= 0', 'brain must be non-negative')
  @Assert('love >= 0', 'love must be non-negative')
  @Assert('sad >= 0', 'sad must be non-negative')
  @Assert('flushed >= 0', 'flushed must be non-negative')
  @Assert('sick >= 0', 'sick must be non-negative')
  @Assert('poo >= 0', 'poo must be non-negative')
  @Assert('thinking >= 0', 'thinking must be non-negative')
  @Assert('sleepy >= 0', 'sleepy must be non-negative')
  @Assert('skull >= 0', 'skull must be non-negative')
  @Assert('mindblown >= 0', 'mindblown must be non-negative')
  @Assert('respect >= 0', 'respect must be non-negative')
  const factory ReactionCounts({
    @Default(0) int fire,
    @Default(0) int brain,
    @Default(0) int love,
    @Default(0) int sad,
    @Default(0) int flushed,
    @Default(0) int sick,
    @Default(0) int poo,
    @Default(0) int thinking,
    @Default(0) int sleepy,
    @Default(0) int skull,
    @Default(0) int mindblown,
    @Default(0) int respect,
  }) = _ReactionCounts;

  const ReactionCounts._();

  factory ReactionCounts.fromJson(Map<String, Object?> json) => ReactionCounts(
    fire: _readCount(json, .fire),
    brain: _readCount(json, .brain),
    love: _readCount(json, .love),
    sad: _readCount(json, .sad),
    flushed: _readCount(json, .flushed),
    sick: _readCount(json, .sick),
    poo: _readCount(json, .poo),
    thinking: _readCount(json, .thinking),
    sleepy: _readCount(json, .sleepy),
    skull: _readCount(json, .skull),
    mindblown: _readCount(json, .mindblown),
    respect: _readCount(json, .respect),
  );

  factory ReactionCounts.single(ReactionType type, int count) =>
      const ReactionCounts()._withValue(type, count);

  int operator [](ReactionType type) => switch (type) {
    .fire => fire,
    .brain => brain,
    .love => love,
    .sad => sad,
    .flushed => flushed,
    .sick => sick,
    .poo => poo,
    .thinking => thinking,
    .sleepy => sleepy,
    .skull => skull,
    .mindblown => mindblown,
    .respect => respect,
  };

  Iterable<MapEntry<ReactionType, int>> get entries sync* {
    for (final type in ReactionType.values) {
      final count = this[type];
      if (count > 0) yield MapEntry(type, count);
    }
  }

  int get total =>
      fire +
      brain +
      love +
      sad +
      flushed +
      sick +
      poo +
      thinking +
      sleepy +
      skull +
      mindblown +
      respect;

  bool get isEmpty => total == 0;

  Map<String, int> toJson() => {
    for (final entry in entries) entry.key.name: entry.value,
  };

  ReactionCounts incremented(ReactionType type) =>
      _withValue(type, this[type] + 1);

  ReactionCounts decremented(ReactionType? type) {
    if (type == null) return this;
    final count = this[type];
    return _withValue(type, count > 0 ? count - 1 : 0);
  }

  ReactionCounts _withValue(ReactionType type, int count) => switch (type) {
    .fire => copyWith(fire: count),
    .brain => copyWith(brain: count),
    .love => copyWith(love: count),
    .sad => copyWith(sad: count),
    .flushed => copyWith(flushed: count),
    .sick => copyWith(sick: count),
    .poo => copyWith(poo: count),
    .thinking => copyWith(thinking: count),
    .sleepy => copyWith(sleepy: count),
    .skull => copyWith(skull: count),
    .mindblown => copyWith(mindblown: count),
    .respect => copyWith(respect: count),
  };

  static int _readCount(Map<String, Object?> json, ReactionType type) {
    final value = json[type.name];
    if (value == null) return 0;
    if (value is! num || !value.isFinite || value < 0 || value % 1 != 0) {
      throw FormatException(
        'Reaction count for ${type.name} must be a non-negative integer',
        value,
      );
    }
    return value.toInt();
  }
}
