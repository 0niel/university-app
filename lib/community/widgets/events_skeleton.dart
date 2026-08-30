import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'events/event_row_skeleton.dart';
part 'events/featured_event_skeleton.dart';
part 'events/ninja_event_skeleton_card.dart';

class EventsSkeleton extends StatelessWidget {
  const EventsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Column(
        children: [
          _FeaturedEventSkeleton(),
          SizedBox(height: 28),
          _EventRowSkeleton(),
          _EventRowSkeleton(),
          _EventRowSkeleton(),
        ],
      ),
    );
  }
}
