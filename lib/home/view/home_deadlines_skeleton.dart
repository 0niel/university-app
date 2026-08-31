import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeDeadlinesSkeleton extends StatelessWidget {
  const HomeDeadlinesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (_) {
        return const Padding(
          padding: .symmetric(vertical: 7),
          child: Row(
            children: [
              NinjaSkeleton(width: 44, height: 44, radius: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    NinjaSkeleton.bar(widthFactor: 0.6),
                    SizedBox(height: 6),
                    NinjaSkeleton.bar(height: 11, widthFactor: 0.4),
                  ],
                ),
              ),
              SizedBox(width: 10),
              NinjaSkeleton(width: 42, height: 12, radius: 6),
            ],
          ),
        );
      }),
    );
  }
}
