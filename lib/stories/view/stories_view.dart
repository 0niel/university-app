import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/stories/widgets/widgets.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({super.key, this.onStoriesLoaded});

  final Function(List<Story>)? onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    return StoriesList(onStoriesLoaded: onStoriesLoaded);
  }
}
