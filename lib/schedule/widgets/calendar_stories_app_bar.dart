import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/ads/ads.dart';

class CalendarStoriesAppBar extends StatefulWidget {
  const CalendarStoriesAppBar({super.key, required this.isStoriesVisible, required this.onStoriesLoaded});

  final bool isStoriesVisible;
  final ValueChanged<bool> onStoriesLoaded;

  @override
  State<CalendarStoriesAppBar> createState() => _CalendarStoriesAppBarState();
}

class _CalendarStoriesAppBarState extends State<CalendarStoriesAppBar> {
  double _stickyAdHeight = kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    if (!context.read<AdsBloc>().state.showAds) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverAppBar(
      pinned: false,
      primary: false,
      expandedHeight: _stickyAdHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: MeasuredStickyAd(
            onMeasured: (height) {
              if (height != _stickyAdHeight) {
                setState(() {
                  _stickyAdHeight = height;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
