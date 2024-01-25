import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news_tags.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({
    required this.getNews,
    required this.getNewsTags,
  }) : super(NewsInitial()) {
    on<NewsLoadEvent>(
      _onNewsLoadEvent,

      // This transformer allows process only the latest event and cancel
      // previous event handlers
      transformer: restartable(),
    );
  }

  final pageSize = 10;

  final GetNews getNews;
  final GetNewsTags getNewsTags;

  String? _getTagOrNull(String? tag) {
    if (tag == null) return null;

    if (tag == 'все') return null;

    return tag;
  }

  static bool isTagsNotEmpty(List<String> tags) {
    if (tags.isEmpty) {
      return false;
    } else if (tags.length == 1 && tags[0].isEmpty) {
      return false;
    }

    return true;
  }

  void _onNewsLoadEvent(NewsLoadEvent event, Emitter<NewsState> emit) async {
    if (state is NewsLoaded) {
      final st = state as NewsLoaded;

      emit(NewsLoading(isFirstFetch: event.refresh == true));

      final newsEither = await getNews(
        GetNewsParams(
          page: event.refresh == true ? 1 : st.page + 1,
          pageSize: pageSize,
          isImportant: event.isImportant,
          tag: _getTagOrNull(event.tag),
        ),
      );

      newsEither.fold(
        (l) => emit(NewsLoadError()),
        (r) {
          emit(NewsLoaded(
            news: event.refresh == true ? r : (st.news + r).toSet().toList(),
            tags: st.tags,
            selectedTag: event.tag,
            page: st.page + 1,
          ));
        },
      );
    } else {
      emit(NewsLoading(isFirstFetch: event.refresh == true));

      final newsEither = await getNews(
        GetNewsParams(
          page: 1,
          pageSize: pageSize,
          isImportant: event.isImportant,
          tag: _getTagOrNull(event.tag),
        ),
      );

      final tagsEither = await getNewsTags();

      newsEither.fold(
        (l) => emit(NewsLoadError()),
        (r) {
          tagsEither.fold(
            (l) => emit(NewsLoadError()),
            (tags) {
              emit(NewsLoaded(
                news: r,
                tags: tags,
                selectedTag: event.tag,
                page: 1,
              ));
            },
          );
        },
      );
    }
  }
}
