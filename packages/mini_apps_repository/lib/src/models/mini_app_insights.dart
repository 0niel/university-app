import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/src/models/mini_app_screen.dart';

part 'mini_app_insights.freezed.dart';
part 'mini_app_insights.g.dart';

/// Sort order for the mini-app catalog.
enum MiniAppSort {
  /// Most launched apps first.
  popular,

  /// Most recently published apps first.
  newest,

  /// Highest-rated apps first.
  top;

  /// Serializes the sort order for the catalog RPC.
  String get wireName => switch (this) {
    MiniAppSort.newest => 'new',
    MiniAppSort.top => 'top',
    MiniAppSort.popular => 'popular',
  };
}

/// One date bucket of mini-app launch statistics.
@freezed
abstract class MiniAppDailyStat with _$MiniAppDailyStat {
  /// Creates a statistics bucket.
  const factory MiniAppDailyStat({
    @JsonKey(fromJson: _dayFromJson, toJson: _dateToJson) required DateTime day,
    @JsonKey(fromJson: _intFromJson) @Default(0) int launches,
    @JsonKey(fromJson: _intFromJson) @Default(0) int uniqueUsers,
  }) = _MiniAppDailyStat;

  /// Deserializes an insights RPC row.
  factory MiniAppDailyStat.fromJson(Map<String, dynamic> json) =>
      _$MiniAppDailyStatFromJson(json);
}

/// A saved revision of a hosted mini app.
@freezed
abstract class MiniAppRevision with _$MiniAppRevision {
  /// Creates a revision snapshot.
  const factory MiniAppRevision({
    @JsonKey(fromJson: _intFromJson) @Default(0) int version,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? createdAt,
    @Default(<MiniAppScreen>[]) List<MiniAppScreen> screens,
  }) = _MiniAppRevision;

  /// Deserializes a revision RPC row.
  factory MiniAppRevision.fromJson(Map<String, dynamic> json) =>
      _$MiniAppRevisionFromJson(json);

  const MiniAppRevision._();

  /// Paths captured in this revision.
  List<String> get paths => screens.map((screen) => screen.path).toList();
}

/// Metadata for a mini-app deploy token.
@freezed
abstract class MiniAppDeployToken with _$MiniAppDeployToken {
  /// Creates deploy-token metadata.
  const factory MiniAppDeployToken({
    @Default('') String id,
    @Default('') String name,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? lastUsedAt,
  }) = _MiniAppDeployToken;

  /// Deserializes a deploy-token RPC row.
  factory MiniAppDeployToken.fromJson(Map<String, dynamic> json) =>
      _$MiniAppDeployTokenFromJson(json);
}

/// One-time deploy token returned only at creation.
@freezed
abstract class CreatedMiniAppDeployToken with _$CreatedMiniAppDeployToken {
  /// Creates the one-time deploy-token result.
  const factory CreatedMiniAppDeployToken({
    required String id,
    required String token,
  }) = _CreatedMiniAppDeployToken;
}

/// Metadata for a remote mini-app signing secret.
@freezed
abstract class MiniAppSigningSecretInfo with _$MiniAppSigningSecretInfo {
  /// Creates signing-secret metadata without exposing the plaintext value.
  const factory MiniAppSigningSecretInfo({
    @Default(false) bool hasSecret,
    String? fingerprint,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? rotatedAt,
    @Default(false) bool previousActive,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? previousExpiresAt,
  }) = _MiniAppSigningSecretInfo;

  /// Deserializes a signing-secret RPC payload.
  factory MiniAppSigningSecretInfo.fromJson(Map<String, dynamic> json) =>
      _$MiniAppSigningSecretInfoFromJson(json);
}

/// One-time signing secret returned after rotation.
@freezed
abstract class CreatedMiniAppSigningSecret with _$CreatedMiniAppSigningSecret {
  /// Creates the one-time signing-secret result.
  const factory CreatedMiniAppSigningSecret({
    required String secret,
    required String fingerprint,
  }) = _CreatedMiniAppSigningSecret;
}

/// Result of validating a mini-app screen payload.
@freezed
abstract class MiniAppValidation with _$MiniAppValidation {
  /// Creates a validation result.
  const factory MiniAppValidation({
    @JsonKey(fromJson: _stringsFromJson)
    @Default(<String>[])
    List<String> unknownWidgets,
    @JsonKey(fromJson: _stringsFromJson)
    @Default(<String>[])
    List<String> unknownActions,
  }) = _MiniAppValidation;

  /// Deserializes a validation RPC payload.
  factory MiniAppValidation.fromJson(Map<String, dynamic> json) =>
      _$MiniAppValidationFromJson(json);

  const MiniAppValidation._();

  /// Whether every widget and action was recognized.
  bool get isClean => unknownWidgets.isEmpty && unknownActions.isEmpty;
}

DateTime _dayFromJson(Object? value) => value is String
    ? (DateTime.tryParse(value) ?? DateTime(2000))
    : DateTime(2000);

DateTime? _localDateFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

String? _dateToJson(DateTime? value) => value?.toUtc().toIso8601String();

int _intFromJson(Object? value) => value is num ? value.toInt() : 0;

List<String> _stringsFromJson(Object? value) =>
    value is List ? value.whereType<String>().toList() : const [];
