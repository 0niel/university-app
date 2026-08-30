import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/src/models/mini_app.dart';
import 'package:mini_apps_repository/src/models/mini_app_report.dart';

part 'moderation_queue.freezed.dart';
part 'moderation_queue.g.dart';

/// A moderation action that changes a mini-app lifecycle state.
enum MiniAppModerationAction {
  /// Publishes a submitted app.
  approve,

  /// Returns an app to its owner for changes.
  reject,

  /// Hides a published app.
  suspend,

  /// Restores a suspended app.
  restore,
}

/// A mini app paired with its currently open reports.
@Freezed(toJson: false)
abstract class ReportedMiniApp with _$ReportedMiniApp {
  /// Creates a reported-app queue entry.
  const factory ReportedMiniApp({
    required MiniApp app,
    @Default(<MiniAppReport>[]) List<MiniAppReport> reports,
  }) = _ReportedMiniApp;

  /// Deserializes a moderation RPC row.
  factory ReportedMiniApp.fromJson(Map<String, dynamic> json) =>
      _$ReportedMiniAppFromJson(json);
}

/// Pending submissions and apps with unresolved reports.
@Freezed(toJson: false)
abstract class MiniAppsModerationQueue with _$MiniAppsModerationQueue {
  /// Creates a moderation queue snapshot.
  const factory MiniAppsModerationQueue({
    @Default(<MiniApp>[]) List<MiniApp> pending,
    @Default(<ReportedMiniApp>[]) List<ReportedMiniApp> reported,
  }) = _MiniAppsModerationQueue;

  /// Deserializes a moderation RPC payload.
  factory MiniAppsModerationQueue.fromJson(Map<String, dynamic> json) =>
      _$MiniAppsModerationQueueFromJson(json);

  const MiniAppsModerationQueue._();

  /// Whether no submission or report needs review.
  bool get isEmpty => pending.isEmpty && reported.isEmpty;
}
