// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportedMiniApp _$ReportedMiniAppFromJson(Map<String, dynamic> json) =>
    _ReportedMiniApp(
      app: MiniApp.fromJson(json['app'] as Map<String, dynamic>),
      reports:
          (json['reports'] as List<dynamic>?)
              ?.map((e) => MiniAppReport.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MiniAppReport>[],
    );

_MiniAppsModerationQueue _$MiniAppsModerationQueueFromJson(
  Map<String, dynamic> json,
) => _MiniAppsModerationQueue(
  pending:
      (json['pending'] as List<dynamic>?)
          ?.map((e) => MiniApp.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MiniApp>[],
  reported:
      (json['reported'] as List<dynamic>?)
          ?.map((e) => ReportedMiniApp.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReportedMiniApp>[],
);
