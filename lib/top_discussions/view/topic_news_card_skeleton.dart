import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TopicNewsCardSkeleton extends StatelessWidget {
  const TopicNewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      width: 296,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NinjaSkeleton.avatar(size: 22),
              SizedBox(width: 8),
              Expanded(child: NinjaSkeleton.bar(height: 11, widthFactor: 0.5)),
            ],
          ),
          SizedBox(height: 14),
          NinjaSkeleton.bar(),
          SizedBox(height: 8),
          NinjaSkeleton.bar(widthFactor: 0.7),
          Spacer(),
          NinjaSkeleton.bar(height: 11, widthFactor: 0.35),
        ],
      ),
    );
  }
}
