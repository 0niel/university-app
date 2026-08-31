import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/communities/communities.dart';

class CommunitiesPreviewContent extends StatelessWidget {
  const CommunitiesPreviewContent({required this.state, super.key});

  final CommunityCatalogState state;

  @override
  Widget build(BuildContext context) {
    final entries = state.featured.take(4).toList();
    if (entries.isEmpty) return const NinjaCommunityCatalogEmpty();
    return Stack(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (_, index) {
            final entry = entries[index];
            return NinjaCommunityCard(
              entry: entry,
              showDescription: true,
            ).animateListItem(key: ValueKey(entry.id), index: index);
          },
        ),
        if (state.isRefreshing)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NinjaProgressBar(value: 1, tone: .ink, height: 2),
          ),
      ],
    );
  }
}
