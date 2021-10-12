part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class NewsLoadTagsEvent extends NewsEvent {}

class NewsLoadEvent extends NewsEvent {
  final bool? refresh;

  const NewsLoadEvent({this.refresh});
}
