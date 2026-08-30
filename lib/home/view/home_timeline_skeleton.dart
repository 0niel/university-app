import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeTimelineSkeleton extends StatelessWidget {
  const HomeTimelineSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (_) {
        return const Padding(
          padding: .symmetric(vertical: 9),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: 52,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    NinjaSkeleton(width: 42, height: 13, radius: 5),
                    SizedBox(height: 6),
                    NinjaSkeleton(width: 34, height: 9, radius: 4),
                  ],
                ),
              ),
              NinjaSkeleton(width: 4, height: 54, radius: 2),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    NinjaSkeleton.bar(widthFactor: 0.76),
                    SizedBox(height: 6),
                    NinjaSkeleton.bar(height: 11, widthFactor: 0.35),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
