import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({
    Key? key,
    this.onStoriesLoaded,
  }) : super(key: key);

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
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final params = StorylyParam()
      ..storylyId = Env.storylyId
      ..storyGroupSize = "custom"
      ..storyGroupListHorizontalEdgePadding = 16
      ..storyGroupListHorizontalPaddingBetweenItems = 8
      ..storyGroupTextIsVisible = true
      ..storyGroupTextColorSeen = AppTheme.colorsOf(context).active
      ..storyGroupIconHeight = (80 * devicePixelRatio).round()
      ..storyGroupIconWidth = (80 * devicePixelRatio).round();

    return SizedBox(
      height: 80,
      child: StorylyView(
        onStorylyViewCreated: onStorylyViewCreated,
        androidParam: params,
        iosParam: params,
        storylyLoaded: (storyGroups, dataSource) {
          final stories = storyGroups.map((st) => st.stories).expand((element) => element).toList();
          widget.onStoriesLoaded?.call(stories);
        },
      ),
    );
  }
}
