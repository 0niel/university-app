part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class NewsLoadTagsEvent extends NewsEvent {}

class NewsLoadEvent extends NewsEvent {
  final bool isImportant;
  final bool? refresh;
  final String? tag;

  const NewsLoadEvent({required this.isImportant, this.refresh, this.tag});

  @override
  List<Object> get props => [isImportant];
}
