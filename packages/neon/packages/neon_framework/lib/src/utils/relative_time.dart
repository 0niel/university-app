import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';

/// Extension for formatting the difference between two [DateTime]s.
@internal
extension RelativeTimeFormatDateTime on DateTime {
  /// Format the relative time between this and [to].
  ///
  /// If [to] is unspecified [DateTime.now] will be used.
  /// Set [includeSign] to skip the parts that tell if the difference is into the future or into the past.
  /// It should only be used if it is already clear from the context if it is about the future or the past.
  String formatRelative(
    NeonLocalizations localizations, {
    bool includeSign = true,
    DateTime? to,
  }) =>
      toLocal().difference(to ?? DateTime.now()).formatRelative(
            localizations,
            includeSign: includeSign,
          );
}

/// Extension for formatting difference of a [Duration].
@internal
extension RelativeTimeFormatDuration on Duration {
  /// Format the relative time.
  ///
  /// Set [includeSign] to skip the parts that tell if the difference is into the future or into the past.
  /// It should only be used if it is already clear from the context if it is about the future or the past.
  String formatRelative(
    NeonLocalizations localizations, {
    bool includeSign = true,
  }) {
    final normalizedDuration = isNegative ? Duration(microseconds: -inMicroseconds) : this;
    if (normalizedDuration.inMinutes < 1) {
      return localizations.relativeTimeNow;
    }

    String time;
    if (normalizedDuration.inHours < 1) {
      time = localizations.relativeTimeMinutes(normalizedDuration.inMinutes);
    } else if (normalizedDuration.inDays < 1) {
      time = localizations.relativeTimeHours(normalizedDuration.inHours);
    } else if (normalizedDuration.inDays < 365) {
      time = localizations.relativeTimeDays(normalizedDuration.inDays);
    } else {
      time = localizations.relativeTimeYears(normalizedDuration.inDays ~/ 365);
    }

    if (!includeSign) {
      return time;
    }

    if (isNegative) {
      return localizations.relativeTimePast(time);
    } else {
      return localizations.relativeTimeFuture(time);
    }
  }
}
