import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'home_service_skeleton_item.dart';

class HomeServicesSkeleton extends StatelessWidget {
  const HomeServicesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        4,
      ),
      child: SizedBox(
        height: 88,
        child: Padding(
          padding: .symmetric(horizontal: 2, vertical: 6),
          child: Row(
            children: [
              Expanded(child: _HomeServiceSkeletonItem()),
              Expanded(child: _HomeServiceSkeletonItem()),
              Expanded(child: _HomeServiceSkeletonItem()),
            ],
          ),
        ),
      ),
    );
  }
}
