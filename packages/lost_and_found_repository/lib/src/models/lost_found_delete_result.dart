import 'package:freezed_annotation/freezed_annotation.dart';

part 'lost_found_delete_result.freezed.dart';

@freezed
abstract class LostFoundDeleteResult with _$LostFoundDeleteResult {
  const factory LostFoundDeleteResult({
    @Default(<String>[]) List<String> failedCleanupPaths,
  }) = _LostFoundDeleteResult;

  const LostFoundDeleteResult._();

  bool get hasCleanupFailure => failedCleanupPaths.isNotEmpty;
}
