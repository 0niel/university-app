part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class NewsLoadTagsEvent extends NewsEvent {
  @override
  List<Object?> get props => [];
}

class NewsLoadEvent extends NewsEvent with AnalyticsEventMixin {
  final bool isImportant;
  final bool? refresh;
  final String? tag;

  const NewsLoadEvent({required this.isImportant, this.refresh, this.tag});

  @override
  AnalyticsEvent get event => AnalyticsEvent(
        'NewsLoad',
        properties: {
          'tag': tag,
        },
      );

  @override
  List<Object> get props => [isImportant];
}
