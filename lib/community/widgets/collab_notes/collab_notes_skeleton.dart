import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CollabNotesSkeleton extends StatelessWidget {
  const CollabNotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const .fromLTRB(0, 8, 0, 96),
        itemCount: 6,
        itemBuilder: (itemContext, _) => Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            0,
            NinjaMetrics.screenPadding,
            10,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: itemContext.ninja.surface,
              borderRadius: BorderRadius.circular(NinjaRadius.card),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  NinjaSkeleton(
                    width: 44,
                    height: 44,
                    radius: NinjaRadius.control,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        NinjaSkeleton.bar(widthFactor: 0.6),
                        NinjaSkeleton.bar(height: 11, widthFactor: 0.4),
                        NinjaSkeleton.bar(height: 11),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
