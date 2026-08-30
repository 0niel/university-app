import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class RevisionsSkeleton extends StatelessWidget {
  const RevisionsSkeleton({required this.canRestore, super.key});

  final bool canRestore;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        mainAxisSize: .min,
        children: [
          for (var index = 0; index < 5; index++)
            Container(
              margin: const .only(bottom: 8),
              padding: const .all(14),
              decoration: BoxDecoration(
                color: context.ninja.surface,
                borderRadius: BorderRadius.circular(NinjaRadius.card),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 6,
                      children: [
                        NinjaSkeleton(width: 60, height: 13),
                        NinjaSkeleton(width: 140, height: 11),
                      ],
                    ),
                  ),
                  if (canRestore && index != 0)
                    const NinjaSkeleton(width: 64, height: 36, radius: 9),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
