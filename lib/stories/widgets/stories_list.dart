import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({super.key, this.onStoriesLoaded});

  final Function(List<Story>)? onStoriesLoaded;

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  late StorylyViewController storylyViewController;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
