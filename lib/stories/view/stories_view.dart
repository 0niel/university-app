import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/stories/widgets/widgets.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({Key? key, this.onStoriesLoaded}) : super(key: key);

  final Function(List<Story>)? onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    return StoriesList(onStoriesLoaded: onStoriesLoaded);
    // return BlocBuilder<StoriesBloc, StoriesState>(builder: (context, state) {
    //   if (state is StoriesInitial) {
    //     context.read<StoriesBloc>().add(LoadStories());
    //   } else if (state is StoriesLoaded) {
    //     final actualStories = StoriesBloc.getActualStories(state.stories);
    //     if (actualStories.isNotEmpty) {
    //       return StoriesList();
    //     } else {
    //       return const SizedBox.shrink();
    //     }
    //   }
    //   return const SizedBox.shrink();
    // });
  }
}
