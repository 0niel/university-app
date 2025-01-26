import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TopicsSkeletonCard extends StatelessWidget {
  const TopicsSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = min(
      320.0,
      MediaQuery.of(context).size.width - 64,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 0,
        maxWidth: maxWidth,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).extension<AppColors>()!.background02,
        ),
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          width: max(320, MediaQuery.of(context).size.width - 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Skeleton(height: 96),
              const SizedBox(height: 16),
              Row(
                children: [
                  Skeleton(height: 42, width: 42, borderRadius: BorderRadius.circular(21)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(height: 16, width: maxWidth - 64 - 16 - 16),
                      const SizedBox(height: 8),
                      Skeleton(
                        height: 16,
                        width: max(0, (maxWidth - 64 - 16 - 16) * 0.75),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
