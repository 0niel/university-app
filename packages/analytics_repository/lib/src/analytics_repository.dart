import 'package:analytics_repository/src/analytics_failure.dart';
import 'package:analytics_repository/src/models/analytics_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AnalyticsRepository {
  const AnalyticsRepository([FirebaseAnalytics? analytics])
    : _analytics = analytics;

  final FirebaseAnalytics? _analytics;

  Future<void> track(AnalyticsEvent event) async {
    try {
      await _analytics?.logEvent(
        name: event.name,
        parameters: event.properties?.map(
          (key, value) => MapEntry(key, value as Object),
        ),
      );
    } on MissingPluginException catch (error, stackTrace) {
      if (_isDesktopOrWeb) return;
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      if (_isChannelError(error)) return;
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    }
  }

  Future<void> setUserId(String? userId) async {
    try {
      await _analytics?.setUserId(id: userId);
    } on MissingPluginException catch (error, stackTrace) {
      if (_isDesktopOrWeb) return;
      Error.throwWithStackTrace(SetUserIdFailure(error), stackTrace);
    } on PlatformException catch (error, stackTrace) {
      if (_isChannelError(error)) return;
      Error.throwWithStackTrace(SetUserIdFailure(error), stackTrace);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SetUserIdFailure(error), stackTrace);
    }
  }

  bool get _isDesktopOrWeb =>
      kIsWeb ||
      defaultTargetPlatform == .windows ||
      defaultTargetPlatform == .linux ||
      defaultTargetPlatform == .macOS;

  bool _isChannelError(PlatformException error) =>
      error.code == 'channel-error';
}
