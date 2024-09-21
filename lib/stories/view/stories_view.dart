import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/stories/widgets/widgets.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({Key? key, this.onStoriesLoaded}) : super(key: key);

  final Function(List<Story>)? onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    return StoriesList(onStoriesLoaded: onStoriesLoaded);
  }
}
