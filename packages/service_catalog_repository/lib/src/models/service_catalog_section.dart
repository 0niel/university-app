import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_catalog_repository/src/models/service_catalog_entry.dart';

part 'service_catalog_section.freezed.dart';
part 'service_catalog_section.g.dart';

@freezed
abstract class ServiceCatalogSection with _$ServiceCatalogSection {
  const factory ServiceCatalogSection({
    required String key,
    required String title,
    required int sortOrder,
    required List<ServiceCatalogEntry> items,
  }) = _ServiceCatalogSection;

  factory ServiceCatalogSection.fromJson(Map<String, Object?> json) =>
      _$ServiceCatalogSectionFromJson(json.cast());
}
