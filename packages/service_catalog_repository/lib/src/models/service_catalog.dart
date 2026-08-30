import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_catalog_repository/src/models/service_catalog_section.dart';

part 'service_catalog.freezed.dart';
part 'service_catalog.g.dart';

@freezed
abstract class ServiceCatalog with _$ServiceCatalog {
  const factory ServiceCatalog({
    required String organizationId,
    required List<ServiceCatalogSection> sections,
  }) = _ServiceCatalog;

  factory ServiceCatalog.fromJson(Map<String, Object?> json) =>
      _$ServiceCatalogFromJson(json.cast());
}
