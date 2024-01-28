import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_response.g.dart';

@JsonSerializable()
class CategoriesResponse extends Equatable {
  const CategoriesResponse({
    required this.categories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) => _$CategoriesResponseFromJson(json);

  final List<String> categories;

  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);

  @override
  List<Object> get props => [categories];
}
