// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportedMiniApp _$ReportedMiniAppFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ReportedMiniApp', json, ($checkedConvert) {
      final val = _ReportedMiniApp(
        app: $checkedConvert(
          'app',
          (v) => MiniApp.fromJson(v as Map<String, dynamic>),
        ),
        reports: $checkedConvert(
          'reports',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) => MiniAppReport.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const <MiniAppReport>[],
        ),
      );
      return val;
    });

_MiniAppsModerationQueue _$MiniAppsModerationQueueFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MiniAppsModerationQueue', json, ($checkedConvert) {
  final val = _MiniAppsModerationQueue(
    pending: $checkedConvert(
      'pending',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => MiniApp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MiniApp>[],
    ),
    reported: $checkedConvert(
      'reported',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => ReportedMiniApp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReportedMiniApp>[],
    ),
  );
  return val;
});
