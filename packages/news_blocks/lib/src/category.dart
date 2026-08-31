import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// A news category exposed by the catalog API.
@freezed
abstract class Category with _$Category {
  /// Creates a category.
  const factory Category({required String id, required String name}) =
      _Category;

  /// Deserializes a category API payload.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
