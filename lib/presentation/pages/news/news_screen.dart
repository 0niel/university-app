import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'widgets/news_item.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({Key? key}) : super(key: key);

  static const String routeName = '/news';
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _setupScrollController(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Новости"),
      ),
      backgroundColor: DarkThemeColors.background01,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NewsBloc>().add(const NewsLoadEvent(refresh: true));
        },
        child: Column(children: [
          // TODO: Add cliclable tags header!!!
          // BlocBuilder<NewsBloc, NewsState>(buildWhen: (prevState, currentState) {
          //   if (currentState is NewsLoaded && prevState is NewsLoaded)
          //     return currentState.tags != prevState.tags;
          //   else if (currentState is NewsLoaded &&
          //       prevState.runtimeType != NewsLoaded)
          //     return true;
          //   else
          //     return false;
          // }, builder: (context, state) {
          //   if (state is NewsLoaded)
          //     return Padding(
          //       padding: EdgeInsets.only(top: 4, bottom: 16, left: 24, right: 24),
          //       child: Tags(
          //         isClickable: true,
          //         withIcon: true,
          //         tags: state.tags,
          //       ),
          //     );
          //   else
          //     return Container();
          // }),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                List<NewsItem> news = [];
                bool isLoading = false;

                if (state is NewsInitial) {
                  context.read<NewsBloc>().add(const NewsLoadEvent());
                } else if (state is NewsLoaded) {
                  news = state.news;
                } else if (state is NewsLoading && state.isFirstFetch) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NewsLoading) {
                  news = state.oldNews;
                  isLoading = true;
                } else if (state is NewsLoadError) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Text(
                        'Произошла ошибка при загрузке новостей.',
                        textAlign: TextAlign.center,
                        style: DarkTextTheme.title,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index < news.length) {
                      return NewsItemWidget(newsItem: news[index]);
                    } else {
                      Timer(const Duration(milliseconds: 30), () {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                  itemCount: news.length + (isLoading ? 1 : 0),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  void _setupScrollController(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          context.read<NewsBloc>().add(const NewsLoadEvent());
        }
      }
    });
  }
}
