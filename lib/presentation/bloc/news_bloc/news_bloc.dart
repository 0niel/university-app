import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/domain/usecases/news_usecase.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc_event.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsState());
  final NewsData = NewsUsecase.NewsDataRepostory();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is NewsInitital) {
      yield NewsSearchInitial();
      final tags = await NewsData.getTags();
      final news = await NewsData.getNews(
          state.offset, NewsUsecase.limit, NewsUsecase.tag);
      yield NewsState(
        news: state.news + news,
        offset: state.offset + NewsUsecase.limit,
        tags: tags,
      );
    }
    if (event is NewsFetched) {
      yield NewsSearch(
        news: state.news,
        offset: state.offset,
        tags: state.tags,
      );
      final news = await NewsData.getNews(
          state.offset + NewsUsecase.limit, NewsUsecase.limit, NewsUsecase.tag);
      yield NewsState(
        news: state.news + news,
        offset: state.offset + NewsUsecase.limit,
        tags: state.tags,
      );
    }
  }
}
