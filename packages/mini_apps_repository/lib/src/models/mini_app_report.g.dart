// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_app_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MiniAppReport _$MiniAppReportFromJson(Map<String, dynamic> json) =>
    _MiniAppReport(
      id: json['id'] as String?,
      reason:
          $enumDecodeNullable(
            _$MiniAppReportReasonEnumMap,
            json['reason'],
            unknownValue: MiniAppReportReason.other,
          ) ??
          MiniAppReportReason.other,
      details: json['details'] as String? ?? '',
      createdAt: _localDateFromJson(json['createdAt']),
    );

Map<String, dynamic> _$MiniAppReportToJson(_MiniAppReport instance) =>
    <String, dynamic>{
      'reason': _$MiniAppReportReasonEnumMap[instance.reason]!,
      'details': instance.details,
      'createdAt': _dateToJson(instance.createdAt),
    };

const _$MiniAppReportReasonEnumMap = {
  MiniAppReportReason.spam: 'spam',
  MiniAppReportReason.inappropriate: 'inappropriate',
  MiniAppReportReason.broken: 'broken',
  MiniAppReportReason.scam: 'scam',
  MiniAppReportReason.privacy: 'privacy',
  MiniAppReportReason.other: 'other',
};
