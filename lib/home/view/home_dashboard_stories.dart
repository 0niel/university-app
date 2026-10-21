import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/home/cubit/home_stories_cubit.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_stories_rail.dart';

class HomeDashboardStories extends StatelessWidget {
  const HomeDashboardStories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoriesBloc>().state;
    return HomeStoriesRail(
      sources: categories.sources,
      seenSourceIds: context.watch<HomeStoriesCubit>().state,
      onSourceOpened: context.read<HomeStoriesCubit>().markSeen,
      loading:
          categories.status == CategoriesStatus.initial ||
          categories.status == CategoriesStatus.loading,
    );
  }
}
