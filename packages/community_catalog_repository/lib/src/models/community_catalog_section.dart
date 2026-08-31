import 'package:community_catalog_repository/src/models/community_catalog_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_catalog_section.freezed.dart';
part 'community_catalog_section.g.dart';

@freezed
abstract class CommunityCatalogSection with _$CommunityCatalogSection {
  const factory CommunityCatalogSection({
    required String key,
    required String title,
    required String emoji,
    required List<CommunityCatalogEntry> items,
    @Default(0) int sortOrder,
  }) = _CommunityCatalogSection;

  factory CommunityCatalogSection.fromJson(Map<String, Object?> json) =>
      _$CommunityCatalogSectionFromJson(json.cast());
}
