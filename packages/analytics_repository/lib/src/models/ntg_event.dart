import 'package:analytics_repository/analytics_repository.dart';

/// {@template ntg_event}
/// An analytics event following News Tagging Guidelines event taxonomy.
/// {@endtemplate}
abstract class NTGEvent extends AnalyticsEvent {
  /// {@macro ntg_event}
  NTGEvent({
    required String name,
    required String category,
    required String action,
    required bool nonInteraction,
    String? label,
    Object? value,
    String? hitType,
  }) : super(
          name,
          properties: <String, Object>{
            'eventCategory': category,
            'eventAction': action,
            'nonInteraction': '$nonInteraction',
            if (label != null) 'eventLabel': label,
            if (value != null) 'eventValue': value,
            if (hitType != null) 'hitType': hitType,
          },
        );
}

/// {@template view_news}
/// An analytics event for tracking news article views.
/// {@endtemplate}
class ViewNews extends NTGEvent {
  /// {@macro view_news}
  ViewNews({
    required String articleTitle,
  }) : super(
          name: 'view_news',
          category: 'NTG news',
          action: 'view',
          label: articleTitle,
          nonInteraction: false,
        );
}

/// {@template view_story}
/// An analytics event for tracking story views.
/// {@endtemplate}
class ViewStory extends NTGEvent {
  /// {@macro view_story}
  ViewStory({
    required String storyTitle,
  }) : super(
          name: 'view_story',
          category: 'NTG story',
          action: 'view',
          label: storyTitle,
          nonInteraction: false,
        );
}
