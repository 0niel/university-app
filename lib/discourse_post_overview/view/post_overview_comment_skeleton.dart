import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PostOverviewCommentSkeleton extends StatelessWidget {
  const PostOverviewCommentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surfaceAlt,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NinjaSkeleton(width: 38, height: 38, radius: 19),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NinjaSkeleton.bar(height: 14, widthFactor: 0.45),
                      SizedBox(height: 7),
                      NinjaSkeleton.bar(height: 11, widthFactor: 0.32),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            NinjaSkeleton.bar(height: 14),
            SizedBox(height: 8),
            NinjaSkeleton.bar(height: 14, widthFactor: 0.78),
          ],
        ),
      ),
    );
  }
}
