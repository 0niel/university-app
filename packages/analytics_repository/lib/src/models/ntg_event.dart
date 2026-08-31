import 'package:analytics_repository/analytics_repository.dart';

abstract class NTGEvent extends AnalyticsEvent {
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
           'eventLabel': ?label,
           'eventValue': ?value,
           'hitType': ?hitType,
         },
       );
}

class ViewNews extends NTGEvent {
  ViewNews({required String articleTitle})
    : super(
        name: 'view_news',
        category: 'NTG news',
        action: 'view',
        label: articleTitle,
        nonInteraction: false,
      );
}

class ViewStory extends NTGEvent {
  ViewStory({required String storyTitle})
    : super(
        name: 'view_story',
        category: 'NTG story',
        action: 'view',
        label: storyTitle,
        nonInteraction: false,
      );
}

class SocialShareEvent extends NTGEvent {
  SocialShareEvent()
    : super(
        name: 'social_share',
        category: 'NTG social',
        action: 'social share',
        label: 'OS share menu',
        nonInteraction: false,
      );
}
