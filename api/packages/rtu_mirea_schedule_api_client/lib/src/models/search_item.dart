import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_item.g.dart';

/// {@template search_data}
/// The search data item.
/// {@endtemplate}
@JsonSerializable()
class SearchItem extends Equatable {
  /// {@macro search_data}
  const SearchItem({
    required this.id,
    required this.targetTitle,
    required this.fullTitle,
    required this.scheduleTarget,
    required this.iCalLink,
  });

  /// Converts a `Map<String, dynamic>` into a [SearchItem] instance.
  factory SearchItem.fromJson(Map<String, dynamic> json) => _$SearchItemFromJson(json);

  /// The id of the schedule target.
  final int id;

  @JsonKey(name: 'targetTitle')

  /// The title of the schedule target. For example, "ИКБО-01-19" or if the
  /// schedule target is a teacher, then "Иванов И.И.".
  final String targetTitle;

  @JsonKey(name: 'fullTitle')

  /// The full title of the schedule target. For example, "ИКБО-01-19" or if
  /// the schedule target is a teacher, then "Иванов Иван Иванович".
  final String fullTitle;

  @JsonKey(name: 'scheduleTarget')

  /// The schedule target. This is a number that represents the type of the
  /// schedule target. For example, 1 is a group, 2 is a teacher, 3 is a room.
  final int scheduleTarget;

  @JsonKey(name: 'iCalLink')

  /// The link to the iCal file.
  final String iCalLink;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$SearchItemToJson(this);

  @override
  List<Object> get props => [id, targetTitle, fullTitle, scheduleTarget, iCalLink];
}
