import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/stories/bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/stories/widgets/widgets.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, StoriesState>(builder: (context, state) {
      if (state is StoriesInitial) {
        context.read<StoriesBloc>().add(LoadStories());
      } else if (state is StoriesLoaded) {
        final actualStories = StoriesBloc.getActualStories(state.stories);
        if (actualStories.isNotEmpty) {
          return StoriesList(stories: actualStories);
        } else {
          return const SizedBox();
        }
      }
      return const SizedBox();
    });
  }
}
