import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/src/models/mini_app_permission.dart';

part 'mini_app.freezed.dart';
part 'mini_app.g.dart';

/// Lifecycle state of a mini app.
enum MiniAppStatus {
  /// Visible only to its owner.
  draft,

  /// Awaiting moderation.
  pendingReview,

  /// Visible in the catalog.
  published,

  /// Returned to the owner for changes.
  rejected,

  /// Hidden by moderation.
  suspended;

  /// Parses a backend value, defaulting to [draft].
  static MiniAppStatus fromName(String? name) => switch (name) {
    'pending_review' => MiniAppStatus.pendingReview,
    'published' => MiniAppStatus.published,
    'rejected' => MiniAppStatus.rejected,
    'suspended' => MiniAppStatus.suspended,
    _ => MiniAppStatus.draft,
  };

  /// Serializes the state for the backend.
  String get wireName =>
      this == MiniAppStatus.pendingReview ? 'pending_review' : name;
}

/// Origin of a mini-app screen definition.
enum MiniAppSourceKind {
  /// Screens stored by the platform.
  hosted,

  /// Screens served by an external developer endpoint.
  remote,

  /// A platform-owned service app.
  service;

  /// Parses a backend value, defaulting to [hosted].
  static MiniAppSourceKind fromName(String? name) => switch (name) {
    'remote' => MiniAppSourceKind.remote,
    'service' => MiniAppSourceKind.service,
    _ => MiniAppSourceKind.hosted,
  };
}

/// Catalog category of a mini app.
enum MiniAppCategory {
  /// Study tools.
  study,

  /// Campus services.
  campus,

  /// Utilities.
  tools,

  /// Games and entertainment.
  fun,

  /// Social apps.
  social,

  /// An unknown or uncategorized app.
  other;

  /// Parses a backend value, defaulting to [other].
  static MiniAppCategory fromName(String? name) {
    return MiniAppCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => MiniAppCategory.other,
    );
  }
}

/// A catalog mini app enriched with viewer-specific state.
@freezed
abstract class MiniApp with _$MiniApp {
  /// Creates a mini-app catalog entry.
  const factory MiniApp({
    required String id,
    required String slug,
    required String name,
    @Default('') String description,
    @Default('🧩') String iconEmoji,
    String? iconUrl,
    @Default('#7C5CFF') String accentColor,
    @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
    @Default(MiniAppCategory.other)
    MiniAppCategory category,
    @Default(<String>[]) List<String> tags,
    @JsonKey(fromJson: _sourceKindFromJson, toJson: _sourceKindToJson)
    @Default(MiniAppSourceKind.hosted)
    MiniAppSourceKind sourceKind,
    String? originUrl,
    @Default('/') String entryPath,
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
    @Default(MiniAppStatus.draft)
    MiniAppStatus status,
    String? reviewNotes,
    @Default(1) int version,
    @Default(0) int launchCount,
    @JsonKey(fromJson: _ratingFromJson, toJson: _ratingToJson)
    @Default(0)
    double ratingAvg,
    @Default(0) int ratingCount,
    String? ownerId,
    @Default(false) bool isOwner,
    @Default(false) bool isFeatured,
    int? myRating,
    @Default(false) bool isHidden,
    @Default(false) bool hasMyOpenReport,
    int? openReportCount,
    @JsonKey(
      fromJson: MiniAppPermission.listFromJson,
      toJson: _permissionsToJson,
    )
    @Default(<MiniAppPermission>[])
    List<MiniAppPermission> requestedPermissions,
    @JsonKey(
      fromJson: _nullablePermissionsFromJson,
      toJson: _nullablePermissionsToJson,
    )
    List<MiniAppPermission>? grantedPermissions,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? publishedAt,
  }) = _MiniApp;

  /// Deserializes a mini-app RPC row.
  factory MiniApp.fromJson(Map<String, dynamic> json) =>
      _$MiniAppFromJson(json);

  const MiniApp._();

  /// Whether the viewer must decide on requested remote-app permissions.
  bool get needsConsent =>
      sourceKind == MiniAppSourceKind.remote &&
      requestedPermissions.isNotEmpty &&
      grantedPermissions == null;
}

MiniAppStatus _statusFromJson(Object? value) =>
    MiniAppStatus.fromName(value as String?);

String _statusToJson(MiniAppStatus value) => value.wireName;

MiniAppSourceKind _sourceKindFromJson(Object? value) =>
    MiniAppSourceKind.fromName(value as String?);

String _sourceKindToJson(MiniAppSourceKind value) => value.name;

MiniAppCategory _categoryFromJson(Object? value) =>
    MiniAppCategory.fromName(value as String?);

String _categoryToJson(MiniAppCategory value) => value.name;

double _ratingFromJson(Object? value) => switch (value) {
  final num number => number.toDouble(),
  final String string => double.tryParse(string) ?? 0,
  _ => 0,
};

num _ratingToJson(double value) => value;

List<String> _permissionsToJson(List<MiniAppPermission> values) =>
    values.map((value) => value.name).toList(growable: false);

List<MiniAppPermission>? _nullablePermissionsFromJson(Object? value) =>
    value == null ? null : MiniAppPermission.listFromJson(value);

List<String>? _nullablePermissionsToJson(List<MiniAppPermission>? values) =>
    values == null ? null : _permissionsToJson(values);

DateTime? _localDateFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

String? _dateToJson(DateTime? value) => value?.toUtc().toIso8601String();
