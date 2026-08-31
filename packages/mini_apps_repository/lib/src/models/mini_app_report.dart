import 'package:freezed_annotation/freezed_annotation.dart';

part 'mini_app_report.freezed.dart';
part 'mini_app_report.g.dart';

/// The moderation reason attached to a mini-app report.
enum MiniAppReportReason {
  /// Unsolicited advertising.
  spam,

  /// Inappropriate content.
  inappropriate,

  /// A non-working app.
  broken,

  /// Fraud or phishing.
  scam,

  /// Improper personal-data handling.
  privacy,

  /// Unknown or uncategorized report.
  other;

  /// Parses a wire value, falling back to [other].
  static MiniAppReportReason fromName(String? name) {
    return MiniAppReportReason.values.firstWhere(
      (reason) => reason.name == name,
      orElse: () => MiniAppReportReason.other,
    );
  }
}

@freezed
/// A moderation report submitted for a mini app.
abstract class MiniAppReport with _$MiniAppReport {
  /// Creates a report payload.
  const factory MiniAppReport({
    @JsonKey(includeToJson: false) String? id,
    @JsonKey(unknownEnumValue: MiniAppReportReason.other)
    @Default(MiniAppReportReason.other)
    MiniAppReportReason reason,
    @Default('') String details,
    @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)
    DateTime? createdAt,
  }) = _MiniAppReport;

  /// Deserializes a moderation API payload.
  factory MiniAppReport.fromJson(Map<String, dynamic> json) =>
      _$MiniAppReportFromJson(json);
}

DateTime? _localDateFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

String? _dateToJson(DateTime? value) => value?.toUtc().toIso8601String();
