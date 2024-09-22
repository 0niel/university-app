import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:storyly_flutter/storyly_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final iosParams = StorylyParam()
      ..storylyId = Env.storylyId
      ..storyGroupSize = "custom"
      ..storyGroupListHorizontalEdgePadding = 16
      ..storyGroupListHorizontalPaddingBetweenItems = 8
      ..storyGroupTextIsVisible = true
      ..storyGroupTextColorSeen = AppTheme.colorsOf(context).active
      ..storyGroupTextColorNotSeen = AppTheme.colorsOf(context).active
      ..storyGroupIconHeight = 70
      ..storyGroupIconWidth = 70
      ..storyGroupTextLines = 2
      ..storyGroupIconCornerRadius = 50
      ..storylyLocale = 'ru-RU';

    final androidParams = StorylyParam()
      ..storylyId = Env.storylyId
      ..storyGroupSize = "custom"
      ..storyGroupListHorizontalEdgePadding = (16 * devicePixelRatio).round()
      ..storyGroupListHorizontalPaddingBetweenItems = (8 * devicePixelRatio).round()
      ..storyGroupTextIsVisible = true
      ..storyGroupTextColorSeen = AppTheme.colorsOf(context).active
      ..storyGroupTextColorNotSeen = AppTheme.colorsOf(context).active
      ..storyGroupIconHeight = (70 * devicePixelRatio).round()
      ..storyGroupIconWidth = (70 * devicePixelRatio).round()
      ..storyGroupTextLines = 2
      ..storyGroupIconCornerRadius = (50 * devicePixelRatio).round()
      ..storylyLocale = 'ru-RU';

    return SizedBox(
      height: 70,
      child: StorylyView(
        onStorylyViewCreated: onStorylyViewCreated,
        androidParam: androidParams,
        iosParam: iosParams,
        storylyLoaded: (storyGroups, dataSource) {
          final stories = storyGroups.map((st) => st.stories).expand((element) => element).toList();
          widget.onStoriesLoaded?.call(stories);
        },
        storylyActionClicked: (story) {
          final url = story.actionUrl;

          if (url != null) {
            launchUrlString(url, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}
