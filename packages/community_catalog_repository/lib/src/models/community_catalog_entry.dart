import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_catalog_entry.freezed.dart';
part 'community_catalog_entry.g.dart';

@freezed
abstract class CommunityCatalogEntry with _$CommunityCatalogEntry {
  const factory CommunityCatalogEntry({
    required String id,
    required String slug,
    required String title,
    required String description,
    required String url,
    required String platform,
    String? logoUrl,
    int? membersCount,
    DateTime? membersCountUpdatedAt,
    @Default(false) bool isFeatured,
    @Default(false) bool isOfficial,
    @Default(0) int sortOrder,
  }) = _CommunityCatalogEntry;

  const CommunityCatalogEntry._();

  factory CommunityCatalogEntry.fromJson(Map<String, Object?> json) =>
      _$CommunityCatalogEntryFromJson(json.cast());

  Uri? get safeUri {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        uri.scheme.toLowerCase() != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    return uri;
  }
}
