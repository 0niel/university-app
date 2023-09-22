import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'groups_response.g.dart';

/// {@template groups_response}
/// Ответ на запрос списка групп
/// {@endtemplate}
@JsonSerializable()
class GroupsResponse extends Equatable {
  /// {@macro groups_response}
  const GroupsResponse({required this.count, required this.groups});

  /// Конвертирует `Map<String, dynamic>` в [GroupsResponse]
  factory GroupsResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupsResponseFromJson(json);

  /// Максимальное количество групп
  final int count;

  /// Список групп
  final List<String> groups;

  /// Конвертирует [GroupsResponse] в `Map<String, dynamic>`
  Map<String, dynamic> toJson() => _$GroupsResponseToJson(this);

  @override
  List<Object> get props => [count, groups];
}
