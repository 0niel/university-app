import 'package:community_catalog_repository/src/models/community_catalog_entry.dart';
import 'package:community_catalog_repository/src/models/community_catalog_section.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_catalog.freezed.dart';
part 'community_catalog.g.dart';

@freezed
abstract class CommunityCatalog with _$CommunityCatalog {
  const factory CommunityCatalog({
    required String organizationId,
    required List<CommunityCatalogSection> sections,
    String? suggestionUrl,
  }) = _CommunityCatalog;

  const CommunityCatalog._();

  factory CommunityCatalog.fromJson(Map<String, Object?> json) =>
      _$CommunityCatalogFromJson(json.cast());

  List<CommunityCatalogEntry> get featured => [
    for (final section in sections)
      ...section.items.where((item) => item.isFeatured),
  ]..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));
}
