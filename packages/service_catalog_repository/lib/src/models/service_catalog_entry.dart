import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_catalog_entry.freezed.dart';
part 'service_catalog_entry.g.dart';

@freezed
abstract class ServiceCatalogEntry with _$ServiceCatalogEntry {
  const factory ServiceCatalogEntry({
    required String id,
    required String slug,
    required String title,
    required String description,
    required String url,
    required String iconKey,
    required String colorKey,
    required int sortOrder,
    String? emoji,
  }) = _ServiceCatalogEntry;

  factory ServiceCatalogEntry.fromJson(Map<String, Object?> json) =>
      _$ServiceCatalogEntryFromJson(json.cast());
}
