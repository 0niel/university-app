import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/ads/ads.dart';

class CalendarStoriesAppBar extends StatelessWidget {
  const CalendarStoriesAppBar({
    super.key,
    required this.isStoriesVisible,
    required this.onStoriesLoaded,
  });

  final bool isStoriesVisible;
  final ValueChanged<bool> onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      primary: true,
      // expandedHeight: 90, <- for stories
      expandedHeight: context.read<AdsBloc>().state.showAds ? 90 : 0,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedOpacity(
          opacity: isStoriesVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          // child: StoriesView(
          //   onStoriesLoaded: (stories) => onStoriesLoaded(stories.isNotEmpty),
          // ),
          child: const StickyAd(),
        ),
      ),
    );
  }
}
