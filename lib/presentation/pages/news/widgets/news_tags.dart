import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'tag_badge.dart';

class NewsTags extends StatelessWidget {
  final List<String> tags;
  final Function(String)? onClick;
  final int maxTags;
  final bool isCompact;

  const NewsTags({super.key, required this.tags, this.onClick, this.maxTags = 2, this.isCompact = false});

  Color _getTagColor(int index, BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorList = [
      colors.colorful01,
      colors.colorful02,
      colors.colorful03,
      colors.colorful04,
      colors.colorful05,
      colors.colorful06,
      colors.colorful07,
    ];

    return colorList[index % colorList.length];
  }

  @override
  Widget build(BuildContext context) {
    final displayTags = tags.length > maxTags ? tags.sublist(0, maxTags) : tags;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          displayTags.length,
          (index) => Padding(
            padding: EdgeInsets.only(right: 6, top: isCompact ? 6 : 8),
            child: TagBadge(
              tag: displayTags[index],
              color: _getTagColor(index, context),
              isCompact: isCompact,
              onPressed: () {
                if (onClick != null) {
                  onClick!(displayTags[index]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
