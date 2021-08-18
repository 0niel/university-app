import 'package:flutter/material.dart';
import 'package:news_page/data/repository/news_data_repository.dart';
import 'package:news_page/presentation/widgets/loader.dart';
import 'package:news_page/presentation/bloc/news_bloc.dart';
import 'package:news_page/presentation/bloc/news_bloc_event.dart';
import 'package:news_page/presentation/bloc/news_bloc_state.dart';
import 'package:news_page/presentation/widgets/tags_widgets.dart';
import 'package:news_page/presentation/widgets/widgets.dart';
import 'package:news_page/domain/usecases/news_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<NewsPage> {
  late ScrollController controller;
  late NewsDataRepository newsUsecase;
  late NewsBloc _news_bloc;
  static const int tags_in_general = 4;

  @override
  void initState() {
    super.initState();
    newsUsecase = NewsUsecase.NewsDataRepostory();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    _news_bloc = BlocProvider.of<NewsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
      if (state is NewsSearchInitial) {
        return Center(
          child: BottomLoader(),
        );
      } else {
        return ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                  padding:
                      EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 16),
                  child: TagsWidget(
                      state.tags.sublist(0, tags_in_general), true, true));
            } else if (index >= state.news.length + 1) {
              return BottomLoader();
            } else {
              return NewsWidget(state.news[index - 1]);
            }
          },
          itemCount: state.news.length + 1 + (state is NewsSearch ? 1 : 0),
        );
      }
    });
  }

  void _scrollListener() {
    if (controller.position.atEdge) {
      if (controller.position.pixels != 0) {
        _news_bloc.add(NewsFetched());
      }
    }
  }
}
