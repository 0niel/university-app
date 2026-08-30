import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleHeaderSkeleton extends StatelessWidget {
  const ScheduleHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        8,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          NinjaSkeleton(width: 176, height: 20),
          SizedBox(height: 7),
          NinjaSkeleton(height: 11, widthFactor: .6, radius: 5),
        ],
      ),
    );
  }
}
