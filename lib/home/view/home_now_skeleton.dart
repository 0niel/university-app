import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeNowSkeleton extends StatelessWidget {
  const HomeNowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final extra = ((scale - 1).clamp(0, 1) * 54).toDouble();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandTint,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const .fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const Row(
              children: [
                NinjaSkeleton(width: 64, height: 12, radius: 6),
                SizedBox(width: 10),
                NinjaSkeleton(width: 84, height: 12, radius: 6),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: .start,
              children: [
                const Column(
                  crossAxisAlignment: .start,
                  children: [
                    NinjaSkeleton(width: 46, height: 20),
                    SizedBox(height: 6),
                    NinjaSkeleton(width: 38, height: 11, radius: 6),
                  ],
                ),
                const SizedBox(width: 12),
                NinjaSkeleton(width: 5, height: 56 + extra, radius: 3),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      NinjaSkeleton.bar(height: 20, widthFactor: .9),
                      SizedBox(height: 8),
                      NinjaSkeleton.bar(height: 20, widthFactor: .55),
                      SizedBox(height: 10),
                      NinjaSkeleton.bar(widthFactor: .46),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
