import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';

import 'widgets.dart';

class StoriesList extends StatelessWidget {
  const StoriesList({
    Key? key,
    required this.stories,
  }) : super(key: key);

  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (_, int i) {
          if (DateTime.now().compareTo(stories[i].stopShowDate) == -1) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: StoryItem(
                stories: stories,
                storyIndex: i,
              ),
            );
          }
          return Container();
        },
        separatorBuilder: (_, int i) => const SizedBox(width: 10),
        itemCount: stories.length,
      ),
    );
  }
}
